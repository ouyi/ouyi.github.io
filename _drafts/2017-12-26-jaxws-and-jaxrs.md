
https://docs.oracle.com/cd/E17802_01/webservices/webservices/docs/2.0/tutorial/doc/JAXWS3.html
https://docs.oracle.com/javaee/6/tutorial/doc/bnayn.html

sei: A service endpoint interface (SEI) is a Java interface that declares the methods that a client can invoke on the service

http://www.mojohaus.org/jaxws-maven-plugin/examples/using-wstools-from-jdk.html
Without toolchains

io.github.ouyi.jaxws.jaxws

docker cp centos-yiou13:/home/yiou13/code/ouyi/jaxws-tutorial/hello-service/target/hello-service-0.0.1.war /tmp/ && docker cp /tmp/hello-service-0.0.1.war glassfish:/tmp/

docker exec -i -u 0 glassfish /bin/bash -c 'asadmin -u admin -W /root/glassfishpwd redeploy --name hello-service-0.0.1 /tmp/hello-service-0.0.1.war'
Application deployed with name hello-service-0.0.1.
Command redeploy executed successfully.

http://www.mojohaus.org/jaxws-maven-plugin/examples/using-wsdlLocation.html


docker cp centos-yiou13:/home/yiou13/code/ouyi/jaxws-tutorial/hello-client/target/hello-client-1.0-SNAPSHOT.jar /tmp/ && docker cp /tmp/hello-client-1.0-SNAPSHOT.jar glassfish:/tmp/

docker exec -i -u 0 glassfish /bin/bash -c 'java -jar /tmp/hello-client-1.0-SNAPSHOT.jar'
Hello, world.

https://www.ibm.com/developerworks/webservices/tutorials/ws-jax/ws-jax.html
https://www.journaldev.com/9123/jax-ws-tutorial


https://spring.io/guides/gs/rest-service/

@Configuration
@EnableAutoConfiguration
@ComponentScan


java -jar home_yiou13/code/ouyi/jaxws-tutorial/service-adapter/build/libs/service-adapter-1.0-SNAPSHOT.jar --server.port=8090


https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-external-config.html



java -jar home_yiou13/code/ouyi/jaxws-tutorial/service-adapter/build/libs/service-adapter-1.0-SNAPSHOT.jar --server.port=8090 --wsdl.location="http://localhost:8080/hello-service-0.0.1/HelloService?wsdl"


Whitelabel Error Page

This application has no explicit mapping for /error, so you are seeing this as a fallback.

Tue Dec 26 23:34:10 CET 2017
There was an unexpected error (type=Internal Server Error, status=500).
Failed to access the WSDL at: http://localhost:8080/hello-service-0.0.1/HelloService?wsdl. It failed with: Unexpected end of file from server.


java -jar home_yiou13/code/ouyi/jaxws-tutorial/service-adapter/build/libs/service-adapter-1.0-SNAPSHOT.jar --server.port=8090 --wsdl.location="http://localhost:18080/hello-service-0.0.1/HelloService?wsdl"

=> OK

https://memorynotfound.com/spring-boot-passing-command-line-arguments-example/
