module Firstep
  module Java
    class WebXmlGenerator
      def create(project_name, target_dir)
        web_xml = File.join(target_dir, 'web.xml')
        File.open(web_xml, 'w') do |file|
          file.write(content(project_name))
        end
      end

      def content(project_name)
        %Q{<!DOCTYPE web-app PUBLIC
        "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
        "http://java.sun.com/dtd/web-app_2_3.dtd" >

<web-app>
    <distributable/>
    <display-name>Web Application</display-name>

    <servlet>
        <servlet-name>#{project_name}</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>/WEB-INF/servlet-context.xml</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>
</web-app>}
      end
    end
  end
end
