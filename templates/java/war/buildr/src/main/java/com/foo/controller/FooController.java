package com.foo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class FooController {
    @RequestMapping("/")
    public String index(ModelMap modelMap) {
        modelMap.addAttribute("name", "foo");
        return "home/index";
    }
}
