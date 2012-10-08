package org.springframework.orm.jpa;

import org.springframework.orm.jpa.persistenceunit.PersistenceUnitManager;

import javax.persistence.spi.PersistenceUnitInfo;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import static com.google.common.collect.Lists.newArrayList;

/* 
 * This is the class which helps to fix SpringFramework PersistenceUnitInfo 
 * generation bug in buildr environment
 */
public class CustomizeLocalContainerEntityManagerFactoryBean extends LocalContainerEntityManagerFactoryBean {
    @Override
    protected PersistenceUnitInfo determinePersistenceUnitInfo(PersistenceUnitManager persistenceUnitManager) {
        PersistenceUnitInfo pui = super.determinePersistenceUnitInfo(persistenceUnitManager);
        URL persistenceUnitRootUrl = pui.getPersistenceUnitRootUrl();
        String url = persistenceUnitRootUrl.toString();
        if (url.endsWith("resources/")) {
            try {
                persistenceUnitRootUrl = new URL(url.replace("resources", "classes"));
                return createPuiWithNewURL(pui, persistenceUnitRootUrl);
            } catch (MalformedURLException ignored) {
            }
        }
        return pui;
    }

    private PersistenceUnitInfo createPuiWithNewURL(final PersistenceUnitInfo pui, final URL url) {

        InvocationHandler handler = new InvocationHandler() {
            @Override
            public Object invoke(Object o, Method method, Object[] objects) throws Throwable {
                if ("getPersistenceUnitRootUrl".equals(method.getName())) {
                    return url;
                }

                return method.invoke(pui, objects);
            }
        };
        return (PersistenceUnitInfo) Proxy.newProxyInstance(getClass().getClassLoader(), new Class[]{PersistenceUnitInfo.class}, handler);
    }
}
