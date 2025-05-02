<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="sheri.Review" %>
<!DOCTYPE html>
<html>
<head>
    <title>Past Reviews</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css">
</head>
<body class="bg-white p-6">
<div class="max-w-3xl mx-auto bg-white p-6 rounded-lg shadow-lg border border-black">
    <h2 class="text-xl font-semibold mb-4 text-black">Past Reviews</h2>

    <div class="text-center mb-6">
        <h3 class="text-lg font-bold text-black"><%= request.getParameter("selectedProfile") %>'s Reviews</h3>
    </div>

    <div class="mb-6">
        <%
            String selectedProfile = request.getParameter("selectedProfile");
            List<Review> reviews = (List<Review>) request.getAttribute("reviews");
            if (reviews != null && !reviews.isEmpty()) {
                for (Review review : reviews) {
        %>
        <div class="border-b border-black pb-3 mb-3">
            <p class="text-black font-semibold"><%= review.getUsername() %> rated <%= review.getRating() %>/5</p>
            <p class="text-gray-700 italic mb-2">"<%= review.getComment() %>"</p>

            <div class="flex gap-2">
                <!-- Edit Form -->
                <form action="ReviewServlet" method="post" class="flex gap-2">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="selectedProfile" value="<%= selectedProfile %>">
                    <input type="hidden" name="originalUsername" value="<%= review.getUsername() %>">
                    <input type="hidden" name="originalRating" value="<%= review.getRating() %>">
                    <input type="hidden" name="originalComment" value="<%= review.getComment() %>">

                    <input type="text" name="username" value="<%= review.getUsername() %>" class="text-black p-1 rounded border">
                    <select name="rating" class="text-black p-1 rounded border">
                        <% for (int i = 1; i <= 5; i++) { %>
                        <option value="<%= i %>" <%= (i == review.getRating()) ? "selected" : "" %>><%= i %></option>
                        <% } %>
                    </select>
                    <input type="text" name="comment" value="<%= review.getComment() %>" class="text-black p-1 rounded border">
                    <button type="submit" class="bg-yellow-500 hover:bg-yellow-600 text-black px-2 py-1 rounded">Update</button>
                </form>

                <!-- Delete Form -->
                <form action="ReviewServlet" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="selectedProfile" value="<%= selectedProfile %>">
                    <input type="hidden" name="username" value="<%= review.getUsername() %>">
                    <input type="hidden" name="rating" value="<%= review.getRating() %>">
                    <input type="hidden" name="comment" value="<%= review.getComment() %>">
                    <button type="submit" class="bg-red-600 hover:bg-red-700 text-white px-2 py-1 rounded">Delete</button>
                </form>
            </div>
        </div>
        <% }} else { %>
        <p class="text-gray-500">No reviews yet for this profile.</p>
        <% } %>
    </div>

    <div class="text-center">
        <a href="index.jsp" class="bg-yellow-500 hover:bg-yellow-600 text-black font-semibold px-4 py-2 rounded transition">Back to Profiles</a>
    </div>
</div>
</body>
</html>
