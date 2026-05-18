<% Boolean footerHideNav = (Boolean) request.getAttribute("hideNav");
   if (footerHideNav == null) footerHideNav = false; %>
    </div> <!-- End Container -->

    <% if (!footerHideNav) { %>
    <footer class="bg-white py-4 mt-auto border-top">
        <div class="container text-center text-muted">
            <p class="mb-0 d-flex justify-content-center align-items-center">
                <i data-lucide="dumbbell" class="me-2" style="width:16px;height:16px;"></i> 
                GymPro Management System &copy; <%= java.time.Year.now().getValue() %>
            </p>
        </div>
    </footer>
    <% } %>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Initialize Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>
