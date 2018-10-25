$(document).ready(function() {
  var notification = document.querySelector("[data-rel='privacy-notification']");
  var dismissButtons = document.querySelector("[data-rel='privacy-notification-dismiss']");
  var cookieName = "privacy_notification_dismissed";
  var cookieValue = Cookies.get(cookieName);

  if (!notification) {
    return false;
  }

  if (cookieValue !== "true") {
    notification.classList.add("show");
  }

  dismissButtons.addEventListener("click", closeNotification);

  function closeNotification() {
    notification.classList.remove("show");

    Cookies.set(cookieName, true, { expires: 365 });
  }
});
