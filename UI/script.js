// Toggle sidebar open/close
const sidebar = document.getElementById("sidebar");
const content = document.querySelector(".content");
const toggleBtn = document.getElementById("toggle-btn");

toggleBtn.addEventListener("click", () => {
  // Toggle sidebar open class
  sidebar.classList.toggle("open");

  // Toggle content margin based on sidebar state
  content.classList.toggle("open");
});
