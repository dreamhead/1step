package com.foo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import com.foo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;

@Controller
public class FooController {
    @Autowired
    private FooRepository repository;

    @RequestMapping("/")
    public String index(ModelMap modelMap) {
        modelMap.addAttribute("name", "foo");
        return "home/index";
    }

    @RequestMapping("/edit")
    public String edit(ModelMap modelMap) {
        return "foo/edit";
    }

    @RequestMapping("/create")
    public String create(ModelMap modelMap) {
        FooEntity entity = new FooEntity("foo", 30, "bar");
        repository.save(entity);
        return "foo/list";
    }

    @RequestMapping("/list")
    public String list(ModelMap modelMap) {
        return "foo/list";
    }
}
