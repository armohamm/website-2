
function GlobalNavDropdowns(globalNav) {
  // Get the elements
  var globalNavDropdowns = this;
  this.container = document.querySelector('.global-navigation'),
  this.root = this.container.querySelector('.nav-root'),
  this.primaryNav = this.root.querySelector('.nav-section.primary'),
  this.primaryNavItem = this.root.querySelector('.nav-section.primary .root-link:last-child'),
  this.secondaryNavItem = this.root.querySelector('.nav-section.secondary .root-link:first-child'),
  this.container.classList.add('no-dropdown-transition'),
  this.dropdownBackground = this.container.querySelector('.dropdown-background'),
  this.dropdownContainer = this.container.querySelector('.dropdown-container'),
  this.dropdownArrow = this.container.querySelector('.dropdown-arrow'),
  this.dropdownRoots = Stut.queryArray('.has-dropdown', this.root),
  this.dropdownSections = Stut.queryArray(
    '.dropdown-section',
    this.container
  ).map(function (GlobalNavDropdowns) {
    return {
      el: GlobalNavDropdowns,
      name: GlobalNavDropdowns.getAttribute('data-dropdown'),
      content: GlobalNavDropdowns.querySelector('.dropdown-content'),
    };
  });

  // Define pointerevents
  var pointerEvents = window.PointerEvent ? {
    end: 'pointerup',
    enter: 'pointerenter',
    leave: 'pointerleave',
  } : {
    end: 'touchend',
    enter: 'mouseenter',
    leave: 'mouseleave',
  };

  this.dropdownRoots.forEach(function (hasDropdown) {
    // Toggle dropdown
    hasDropdown.addEventListener(pointerEvents.end, function (pointerEvents) {
      pointerEvents.preventDefault(),
      pointerEvents.stopPropagation(),
      globalNavDropdowns.toggleDropdown(hasDropdown);
    }),

    // Open dropdown
    hasDropdown.addEventListener(pointerEvents.enter, function (pointerEvents) {
      if (pointerEvents.pointerType == 'touch') return;
      globalNavDropdowns.stopCloseTimeout(),
      globalNavDropdowns.openDropdown(hasDropdown);
    }),

    // Close dropdown
    hasDropdown.addEventListener(pointerEvents.leave, function (hasDropdown) {
      if (hasDropdown.pointerType == 'touch') return;
      globalNavDropdowns.startCloseTimeout();
    });
  }),

  // Prevent bubbling up in DOM for pointerup and touchend
  this.dropdownContainer.addEventListener(pointerEvents.end, function (event) {
    event.stopPropagation();
  }),

  // stopCloseTimeOut on pointerenter or mouseenter
  this.dropdownContainer.addEventListener(pointerEvents.enter, function (event) {
    if (globalNavDropdowns.pointerType == 'touch') return;
    globalNavDropdowns.stopCloseTimeout();
  }),

  // startCloseTimeout on pointerleave or mouseleave
  this.dropdownContainer.addEventListener(pointerEvents.leave, function (event) {
    if (globalNavDropdowns.pointerType == 'touch') return;
    globalNavDropdowns.startCloseTimeout();
  }),

  document.body.addEventListener(pointerEvents.end, function (event) {
    Stut.touch.isDragging || globalNavDropdowns.closeDropdown();
  });
}

// Popup for mobile navigation
function GlobalNavPopup(event) {
  var globalNavPopup = this;
  var inputType = Stut.touch.isSupported ? 'touchend' : 'click';
  this.activeClass = 'globalPopupActive',
  this.root = document.querySelector(event),
  this.link = this.root.querySelector('.root-link'),
  this.popup = this.root.querySelector('.popup'),
  this.closeButton = this.root.querySelector('.popup-close-button'),

  this.link.addEventListener(inputType, function (event) {
      event.stopPropagation(),
      globalNavPopup.togglePopup();
    }),

    this.popup.addEventListener(inputType, function (event) {
        event.stopPropagation();
      }),

    this.closeButton && this.closeButton.addEventListener(inputType, function (event) {
      globalNavPopup.closeAllPopups();
    }),

    document.body.addEventListener(inputType, function (event) {
      Stut.touch.isDragging || globalNavPopup.closeAllPopups();
    }, !1);
}

var Stut = {
  queryArray: function (event, body) {
    return body || (body = document.body), Array.prototype.slice.call(body.querySelectorAll(event));
  },

  ready: function (event) {
    document.readyState !== 'loading' ? event() : document.addEventListener('DOMContentLoaded', event);
  },
};

Stut.isRetina = window.devicePixelRatio > 1.3,
Stut.mobileViewportWidth = 760,
Stut.isMobileViewport = window.innerWidth < Stut.mobileViewportWidth,
window.addEventListener('resize', function () {
  Stut.isMobileViewport = window.innerWidth < Stut.mobileViewportWidth;
}),

Stut.touch = {
  isSupported: 'ontouchstart' in window || navigator.maxTouchPoints,
  isDragging: !1,
},

document.addEventListener('DOMContentLoaded', function () {
  document.body.addEventListener('touchmove', function () {
    Stut.touch.isDragging = !0;
  }),

  document.body.addEventListener('touchstart', function () {
    Stut.touch.isDragging = !1;
  });
}),

Stut.supports = {
  pointerEvents: (function () {
    var event = document.createElement('a').style;
    return event.cssText = 'pointer-events:auto',
    event.pointerEvents === 'auto';
  })(),
},

GlobalNavDropdowns.prototype.openDropdown = function (addActive) {
  var GlobalNavDropdowns = this;
  if (GlobalNavDropdowns.activeDropdown === addActive) return;
  this.container.classList.add('dropdown-active'),
  this.activeDropdown = addActive,
  this.dropdownRoots.forEach(function (addActive, GlobalNavDropdowns) {
    addActive.classList.remove('active');
  }),

  // Active class list to active dropdown
  addActive.classList.add('active');
  var dataDropdown = addActive.getAttribute('data-dropdown');
  var right = 'left';
  var offsetWidth;
  var offsetHeight;
  var content;
  this.dropdownSections.forEach(function (addActive) {
    addActive.el.classList.remove('active'),
    addActive.el.classList.remove('left'),
    addActive.el.classList.remove('right'),
    addActive.name == dataDropdown ? (
      addActive.el.classList.add('active'),
      right = 'right',
      offsetWidth = addActive.content.offsetWidth,
      offsetHeight = addActive.content.offsetHeight,
      content = addActive.content
    ) : addActive.el.classList.add(right);
  });

  var f = offsetWidth / 520;
  var l = offsetHeight / 400;
  var boundingRect = addActive.getBoundingClientRect();
  var widthRect = boundingRect.left + boundingRect.width / 2 - offsetWidth / 2;
  widthRect = Math.round(Math.max(widthRect, 10)),
    clearTimeout(this.disableTransitionTimeout),
    this.enableTransitionTimeout = setTimeout(function () {
      GlobalNavDropdowns.container.classList.remove('no-dropdown-transition');
    }, 30),

    this.dropdownBackground.style.transform =
      'translateX(' + widthRect + 'px) scaleX(' + f + ') scaleY(' + l + ')',
    this.dropdownContainer.style.transform = 'translateX(' + widthRect + 'px)',
    this.dropdownContainer.style.width = offsetWidth + 'px',
    this.dropdownContainer.style.height = offsetHeight + 'px';
  var mathRound = Math.round(boundingRect.left + boundingRect.width / 2);
  this.dropdownArrow.style.transform = 'translateX(' + mathRound + 'px) rotate(45deg)';
  var d = content.children[0].offsetHeight / l;
},

// Close dropdown
GlobalNavDropdowns.prototype.closeDropdown = function () {
  var dropDowncontainer = this;
  if (!this.activeDropdown) return;
  this.dropdownRoots.forEach(function (dropDowncontainer, t) {
    dropDowncontainer.classList.remove('active');
  }),

  clearTimeout(this.enableTransitionTimeout),
  this.disableTransitionTimeout = setTimeout(function () {
    dropDowncontainer.container.classList.add('noDropdownTransition');
  }, 50),

  this.container.classList.remove('dropdown-active'),
  this.activeDropdown = undefined;
},

GlobalNavDropdowns.prototype.toggleDropdown = function (event) {
  this.activeDropdown === event ? this.closeDropdown() : this.openDropdown(event);
},

// Define startCloseTimeout
GlobalNavDropdowns.prototype.startCloseTimeout = function () {
  var dropdownContainer = this;
  dropdownContainer.closeDropdownTimeout = setTimeout(function () {
    dropdownContainer.closeDropdown();
  }, 50);
},

// Define stopCloseTimeOut
GlobalNavDropdowns.prototype.stopCloseTimeout = function () {
  var dropdownContainer = this;
  clearTimeout(dropdownContainer.closeDropdownTimeout);
},

// Define togglePopup
GlobalNavPopup.prototype.togglePopup = function () {
  var popupActiveClass = this.root.classList.contains(this.activeClass);
  this.closeAllPopups(!0), popupActiveClass || this.root.classList.add(this.activeClass);
},

GlobalNavPopup.prototype.closeAllPopups = function (event) {
  var globalPopupActive = document.getElementsByClassName(this.activeClass);
  for (var globalPopupPresent = 0; globalPopupPresent < globalPopupActive.length; globalPopupPresent++) globalPopupActive[globalPopupPresent].classList.remove(this.activeClass);
},

// Initialize on document ready
$(document).ready(function () {
  new GlobalNavDropdowns('.global-navigation'),
  new GlobalNavPopup('.global-navigation .nav-section.mobile');
});
