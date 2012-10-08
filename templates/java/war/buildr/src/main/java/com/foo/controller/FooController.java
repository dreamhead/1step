package com.foo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import com.foo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.request.WebRequest;


@Controller
public class FooController {

    @Autowired
    private FooRepository repository;

    @RequestMapping("/")
    public String index(ModelMap modelMap) {
        modelMap.addAttribute("name", "foo");
        return "home/index";
    }

    @RequestMapping("/foo/edit")
    public String edit(ModelMap modelMap) {
        return "foo/edit";
    }

    @RequestMapping(value = "/foo/create", method = RequestMethod.POST)
    public String create(WebRequest request) {
        String name = (String)request.getParameter("name");
        String data = (String)request.getParameter("data");
        FooEntity foo = new FooEntity(name, 0, data);
        repository.save(foo);
        return "redirect:/foo/list";
    }

    @RequestMapping("/foo/list")
    public String list(ModelMap modelMap) {
        Iterable<FooEntity> entities = repository.findAll();
        modelMap.addAttribute("entities", entities);
        return "foo/list";
    }
}
