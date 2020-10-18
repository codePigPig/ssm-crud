package com.crud.test;

import java.util.Random;
import java.util.UUID;

/**
 * @author CodePigPig
 * @date 2020/10/18 22:37
 * @Email 1399203705@qq.com
 */
public class Test1 {
    public static void main(String[] args) {
        Random random = new Random();
        String w = "W";
        String m = "M";
        String replace = "1";
        for (int i = 0; i < 10; i++) {
            String uuid = UUID.randomUUID().toString().substring(0, 5) + i;
            int sum = random.nextInt(2) + 1;

            if (random.nextInt(10) %2 != 0){
                replace = m;
            }else{
                replace = w;
            }
            System.out.println(replace);
     }
    }
}
