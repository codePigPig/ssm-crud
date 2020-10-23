package com.crud.bean;

import java.util.HashMap;
import java.util.Map;

/**
 * @author CodePigPig
 * @date 2020/10/22 21:18
 * @Email 1399203705@qq.com
 */
    /*通用的返回信息*/
public class Msg {
    //状态码 100-成功 200-失败
    private int code;

    //提示信息
    private String msg;

    //用户要返回给浏览器的数据
    private Map<String,Object> extendData = new HashMap<String,Object>();

    /*处理成功信息*/
    public static Msg success(){
        Msg result = new Msg();
        result.setCode(100);
        result.setMsg("处理成功");
        return result;
    }
    /*处理成功失败*/
    public static Msg fail(){
        Msg result = new Msg();
        result.setCode(200);
        result.setMsg("处理失败");
        return result;
    }

    /*链式操作*/
    public Msg add(String key,Object value){
        this.getExtendData().put(key,value);
        return this;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getExtendData() {
        return extendData;
    }

    public void setExtendData(Map<String, Object> extendData) {
        this.extendData = extendData;
    }
}
