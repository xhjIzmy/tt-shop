package com.qf.ttshop.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * User: asus
 * Date: 2017/11/20
 * Time: 19:28
 * Version:V1.0
 */
@Controller
public class IndexAction {

    @RequestMapping("/")
    public String index(){
        return "index";
    }

    @RequestMapping("/{page}")
    public String page(@PathVariable("page") String page){
        return page;
    }
}
