DispatcherServlet
Front controller vs page controller

Security
with security starter:
default login page
    Using generated security password: a4a6b75e-9b92-44c0-8097-717a449885c8
    Mapping filter: 'springSecurityFilterChain' to: [/*]
    Servlet dispatcherServlet mapped to [/]

authorizeRequests => ExpressionInterceptUrlRegistry

request => container => thread (out of thread pool) => DispatcherSevlet => controller

java -jar build/libs/gs-rest-service-0.1.0.jar --server.port=8888 --server.servlet.contextPath='/rest'
