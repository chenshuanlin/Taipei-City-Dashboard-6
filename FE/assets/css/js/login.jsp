<%@page contentType="text/html" %>
    <%@page pageEncoding="UTF-8" %>
        <%@ page import="java.sql.*" %>
            <%@ page import="java.net.URLEncoder" %>
                <%@ page import="java.net.URLDecoder" %>
                    <%@ page import="java.nio.charset.StandardCharsets" %>

                        <html>

                        <head>
                            <title>Login Success!</title>
                        </head>

                        <body>
                            <% String username=request.getParameter("username"); String
                                password=request.getParameter("password"); String
                                redirectUrl="/E-Commerce-Front-end/index.jsp" ; // String
                                redirectUrl="/E-Commerce-Front-end/" + request.getParameter("redirectUrl"); try {
                                Class.forName("com.mysql.jdbc.Driver"); String url="jdbc:mysql://localhost/new" ;
                                Connection con=DriverManager.getConnection(url,"root","1234"); if(con.isClosed()){
                                out.println("連線建立失敗"); } else { String
                                sql="SELECT * FROM `members` WHERE `username`=? AND `pwd`=?" ; PreparedStatement
                                pstmt=null; pstmt=con.prepareStatement(sql); pstmt.setString(1,username);
                                pstmt.setString(2,password); String userId=null; ResultSet dataset=pstmt.executeQuery();
                                if(dataset.next()){ Cookie usernameCookie=new Cookie("username",username); Cookie
                                nameCookie=new Cookie("username",dataset.getString("username"));
                                userId=dataset.getString("id"); Cookie idCookie=new Cookie("id",userId);
                                usernameCookie.setMaxAge(-1); usernameCookie.setPath("/"); nameCookie.setMaxAge(-1);
                                nameCookie.setPath("/"); idCookie.setMaxAge(-1); idCookie.setPath("/");
                                response.addCookie(usernameCookie); response.addCookie(nameCookie);
                                response.addCookie(idCookie); out.print(redirectUrl); } else{ out.print(redirectUrl);
                                response.sendRedirect("login.jsp?&message=Username or password incorrect, please try
                                again."); return; } sql="SELECT COUNT(*) FROM `cart` WHERE userId = ?;" ;
                                pstmt=con.prepareStatement(sql); pstmt.setInt(1,Integer.parseInt(userId));
                                dataset=pstmt.executeQuery(); dataset.next(); if (dataset.getInt(1)==0){
                                sql="INSERT IGNORE into `cart` (`userId`) VALUES ('" +userId+"')";
                                con.createStatement().executeUpdate(sql); }
                                sql="SELECT id FROM `cart` WHERE `userId` = ? ORDER BY `id` DESC LIMIT 1;" ;
                                pstmt=con.prepareStatement(sql); pstmt.setInt(1,Integer.parseInt(userId));
                                dataset=pstmt.executeQuery(); dataset.next(); Cookie cartCookie=new
                                Cookie("cartid",String.valueOf(dataset.getInt(1))); response.addCookie(cartCookie);
                                response.sendRedirect(redirectUrl); } } catch (SQLException sExec) { out.print(sExec); }
                                %>

                        </body>

                        </html>