package com.foo.controller;

import com.foo.repository.FooRepository;
import org.junit.Before;
import org.junit.Test;
import org.springframework.ui.ModelMap;
import org.springframework.web.context.request.WebRequest;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertThat;
import static org.mockito.Mockito.*;

public class FooControllerTest {

    private FooController controller;
    private ModelMap modelMap;
    private FooRepository mockRepository;

    @Before
    public void before(){
        mockRepository = mock(FooRepository.class);
        controller = new FooController();
        controller.setRepository(mockRepository);
        modelMap = new ModelMap();
    }

    @Test
    public void should_return_person_name() throws Exception {
        assertThat(controller.index(modelMap), is("home/index"));
    }

    @Test
    public void should_return_edit_page() throws Exception{
        assertThat(controller.edit(modelMap), is("foo/edit"));
    }

    @Test
    public void should_redirect_to_list_page_after_created() throws Exception{
        WebRequest mockRequest = mock(WebRequest.class);
        assertThat(controller.create(mockRequest), is("redirect:/foo/list"));
    }

    @Test
    public void should_render_list_page() throws Exception{
        assertThat(controller.list(modelMap), is("foo/list"));
    }
}
