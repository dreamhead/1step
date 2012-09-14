package com.foo.controller;

import org.junit.Test;
import org.springframework.ui.ModelMap;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertThat;

public class FooControllerTest {
    @Test
    public void should_return_person_name() throws Exception {
        FooController controller = new FooController();
        ModelMap modelMap = new ModelMap();
        assertThat(controller.index(modelMap), is("home/index"));
    }
}
