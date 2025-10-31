// Контакты редактируются в одном месте и подтягиваются в интерфейс
const CONTACT = {
  phoneDisplay: "+7 999 000-00-00",
  phoneDial: "+79990000000",
  email: "alan@example.com",
  whatsappDial: "79990000000", // для wa.me без плюса
  telegramUsername: "alan_nutri"
};

// Аналитика: заполните ID, чтобы включить интеграции
const ANALYTICS = {
  yandexMetrikaId: "", // пример: "12345678"
  gaMeasurementId: ""  // пример: "G-XXXXXXX"
};

function setContactLinks() {
  const telLinks = document.querySelectorAll('[data-contact="tel"]');
  telLinks.forEach((a) => {
    a.href = `tel:${CONTACT.phoneDial}`;
    if (!a.textContent.trim()) a.textContent = CONTACT.phoneDisplay;
  });

  const emailLinks = document.querySelectorAll('[data-contact="email"]');
  emailLinks.forEach((a) => {
    a.href = `mailto:${CONTACT.email}`;
    if (!a.textContent.trim()) a.textContent = CONTACT.email;
  });

  const tgLinks = document.querySelectorAll('[data-contact="tg"]');
  tgLinks.forEach((a) => {
    const href = `https://t.me/${CONTACT.telegramUsername}`;
    a.href = href;
    if (!a.textContent.trim()) a.textContent = `@${CONTACT.telegramUsername}`;
  });
}

function initYear() {
  const y = document.getElementById("year");
  if (y) y.textContent = String(new Date().getFullYear());
}

function validateForm(form) {
  const hp = form.querySelector('input[name="hp"]');
  if (hp && hp.value) return { ok: false, msg: "" }; // спам-бот
  if (!form.checkValidity()) {
    return { ok: false, msg: "Проверьте корректность полей формы." };
  }
  const consent = form.querySelector('#consent');
  if (!consent.checked) return { ok: false, msg: "Требуется согласие на обработку данных." };
  return { ok: true };
}

function buildMessage(data) {
  const lines = [
    `Обратный звонок — сайт Алан Ногаев`,
    `Имя: ${data.name}`,
    `Телефон: ${data.phone}`,
    data.time ? `Удобное время: ${data.time}` : null,
    `Способ связи: ${data.method}`,
    data.msg ? `Комментарий: ${data.msg}` : null
  ].filter(Boolean);
  return lines.join("\n");
}

function openWhatsApp(text) {
  if (!CONTACT.whatsappDial) return false;
  const url = `https://wa.me/${CONTACT.whatsappDial}?text=${encodeURIComponent(text)}`;
  window.open(url, "_blank", "noopener");
  return true;
}

function openMailto(subject, body) {
  const url = `mailto:${CONTACT.email}?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`;
  window.location.href = url;
}

function handleFormSubmit() {
  const form = document.getElementById("cbForm");
  const note = document.getElementById("cbNote");
  if (!form) return;

  form.addEventListener("submit", (e) => {
    e.preventDefault();
    note.textContent = "";

    const valid = validateForm(form);
    if (!valid.ok) {
      note.textContent = valid.msg || "Форма не заполнена.";
      return;
    }

    const data = Object.fromEntries(new FormData(form).entries());
    const msg = buildMessage(data);
    const prefer = data.method || "call";

    if (prefer === "whatsapp" && openWhatsApp(msg)) {
      note.textContent = "Открылся WhatsApp с подготовленным сообщением.";
      form.reset();
      return;
    }

    // По умолчанию Email (или если выбран звонок)
    openMailto("Обратный звонок", msg);
    note.textContent = "Мы подготовили письмо в вашей почтовой программе.";
    form.reset();
  });
}

document.addEventListener("DOMContentLoaded", () => {
  setContactLinks();
  initYear();
  handleFormSubmit();
  initSmoothScroll();
  initPhoneMask();
  initFab();
  initWhatsAppQuick();
  initTheme();
  initAnalytics();
});

function initSmoothScroll() {
  const links = document.querySelectorAll('a[href^="#"]');
  links.forEach((a) => {
    const href = a.getAttribute('href');
    if (!href || href === '#') return;
    a.addEventListener('click', (e) => {
      const id = href.slice(1);
      const target = document.getElementById(id);
      if (target) {
        e.preventDefault();
        target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        history.pushState(null, '', `#${id}`);
      }
    });
  });
}

function formatRuPhone(inputDigits) {
  let digits = (inputDigits || '').replace(/\D/g, '');
  if (!digits) return '';
  // нормализуем к российскому формату +7
  if (digits.startsWith('8')) digits = '7' + digits.slice(1);
  if (!digits.startsWith('7')) digits = '7' + digits;
  // +7 9xx xxx-xx-xx
  const parts = [
    '+7',
    digits.slice(1, 2) ? ' ' + digits.slice(1, 2) : '',
    digits.slice(2, 5) ? digits.slice(2, 5) : '',
    digits.slice(5, 8) ? ' ' + digits.slice(5, 8) : '',
    digits.slice(8, 10) ? '-' + digits.slice(8, 10) : '',
    digits.slice(10, 12) ? '-' + digits.slice(10, 12) : ''
  ];
  return parts.join('');
}

function initPhoneMask() {
  const phone = document.getElementById('phone');
  if (!phone) return;
  const apply = () => {
    const caretAtEnd = phone.selectionStart === phone.value.length;
    phone.value = formatRuPhone(phone.value);
    if (caretAtEnd) phone.selectionStart = phone.selectionEnd = phone.value.length;
  };
  ['input', 'blur'].forEach(ev => phone.addEventListener(ev, apply));
}

function initFab() {
  const fab = document.getElementById('fab');
  if (!fab) return;
  const main = fab.querySelector('.fab-main');
  main.addEventListener('click', () => {
    fab.classList.toggle('open');
    const menu = fab.querySelector('.fab-menu');
    menu.setAttribute('aria-hidden', fab.classList.contains('open') ? 'false' : 'true');
  });
  document.addEventListener('click', (e) => {
    if (!fab.contains(e.target)) fab.classList.remove('open');
  });
}

function initWhatsAppQuick() {
  const wa = document.getElementById('fabWa');
  if (!wa) return;
  const sample = `Здравствуйте! Хочу записаться на консультацию.`;
  wa.href = `https://wa.me/${CONTACT.whatsappDial}?text=${encodeURIComponent(sample)}`;
}

function getStoredTheme() {
  try { return localStorage.getItem('theme'); } catch { return null; }
}
function setStoredTheme(theme) {
  try { localStorage.setItem('theme', theme); } catch {}
}
function getPreferredTheme() {
  const stored = getStoredTheme();
  if (stored === 'light' || stored === 'dark') return stored;
  return window.matchMedia('(prefers-color-scheme: light)').matches ? 'light' : 'dark';
}
function applyTheme(theme) {
  const root = document.documentElement;
  if (theme === 'light') root.setAttribute('data-theme', 'light');
  else root.removeAttribute('data-theme');
}
function initTheme() {
  applyTheme(getPreferredTheme());
  const btn = document.getElementById('themeToggle');
  if (!btn) return;
  btn.addEventListener('click', () => {
    const current = document.documentElement.getAttribute('data-theme') === 'light' ? 'light' : 'dark';
    const next = current === 'light' ? 'dark' : 'light';
    applyTheme(next);
    setStoredTheme(next);
  });
}

function initAnalytics() {
  // Яндекс.Метрика
  if (ANALYTICS.yandexMetrikaId) {
    (function(m,e,t,r,i,k,a){m[i]=m[i]||function(){(m[i].a=m[i].a||[]).push(arguments)};
    m[i].l=1*new Date();k=e.createElement(t),a=e.getElementsByTagName(t)[0];k.async=1;k.src=r;a.parentNode.insertBefore(k,a)
    })(window, document, "script", "https://mc.yandex.ru/metrika/tag.js", "ym");
    window.ym(ANALYTICS.yandexMetrikaId, "init", { clickmap:true, trackLinks:true, accurateTrackBounce:true });
    const nos = document.createElement('noscript');
    nos.innerHTML = `<div><img src="https://mc.yandex.ru/watch/${ANALYTICS.yandexMetrikaId}" style="position:absolute; left:-9999px;" alt=""/></div>`;
    document.body.appendChild(nos);
  }

  // Google Analytics 4
  if (ANALYTICS.gaMeasurementId) {
    const s = document.createElement('script');
    s.async = true;
    s.src = `https://www.googletagmanager.com/gtag/js?id=${ANALYTICS.gaMeasurementId}`;
    document.head.appendChild(s);
    window.dataLayer = window.dataLayer || [];
    function gtag(){ window.dataLayer.push(arguments); }
    window.gtag = gtag;
    gtag('js', new Date());
    gtag('config', ANALYTICS.gaMeasurementId);
  }
}

// Mobile Navigation Toggle
const hamburger = document.querySelector('.hamburger');
const navMenu = document.querySelector('.nav-menu');

hamburger.addEventListener('click', () => {
    hamburger.classList.toggle('active');
    navMenu.classList.toggle('active');
});

// Close mobile menu when clicking on a link
document.querySelectorAll('.nav-menu a').forEach(link => {
    link.addEventListener('click', () => {
        hamburger.classList.remove('active');
        navMenu.classList.remove('active');
    });
});

// Smooth scrolling for navigation links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Header background change on scroll
window.addEventListener('scroll', () => {
    const header = document.querySelector('.header');
    if (window.scrollY > 100) {
        header.style.background = 'rgba(255, 255, 255, 0.98)';
    } else {
        header.style.background = 'rgba(255, 255, 255, 0.95)';
    }
});

// Gallery lightbox effect
document.querySelectorAll('.gallery-item').forEach(item => {
    item.addEventListener('click', () => {
        const img = item.querySelector('img');
        const lightbox = document.createElement('div');
        lightbox.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.9);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10000;
            cursor: pointer;
        `;
        
        const lightboxImg = document.createElement('img');
        lightboxImg.src = img.src;
        lightboxImg.style.cssText = `
            max-width: 90%;
            max-height: 90%;
            object-fit: contain;
            border-radius: 10px;
        `;
        
        lightbox.appendChild(lightboxImg);
        document.body.appendChild(lightbox);
        
        lightbox.addEventListener('click', () => {
            document.body.removeChild(lightbox);
        });
    });
});

// Form submission
document.querySelector('.contact-form').addEventListener('submit', (e) => {
    e.preventDefault();
    
    // Get form data
    const formData = new FormData(e.target);
    const name = e.target.querySelector('input[type="text"]').value;
    const email = e.target.querySelector('input[type="email"]').value;
    const phone = e.target.querySelector('input[type="tel"]').value;
    const message = e.target.querySelector('textarea').value;
    
    // Simple validation
    if (!name || !email || !phone || !message) {
        alert('Пожалуйста, заполните все поля');
        return;
    }
    
    // Simulate form submission
    alert('Спасибо за ваше сообщение! Мы свяжемся с вами в ближайшее время.');
    e.target.reset();
});

// Animate elements on scroll
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe elements for animation
document.querySelectorAll('.tour-card, .gallery-item, .about-text, .about-image').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(30px)';
    el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    observer.observe(el);
});

// Parallax effect for hero section
window.addEventListener('scroll', () => {
    const scrolled = window.pageYOffset;
    const hero = document.querySelector('.hero');
    const heroImage = document.querySelector('.hero-image img');
    
    if (hero && heroImage) {
        heroImage.style.transform = `translateY(${scrolled * 0.5}px)`;
    }
});

// Add loading animation
window.addEventListener('load', () => {
    document.body.style.opacity = '0';
    document.body.style.transition = 'opacity 0.5s ease';
    
    setTimeout(() => {
        document.body.style.opacity = '1';
    }, 100);
});

// ==================== CART FUNCTIONALITY ====================

// Cart variables
let cart = [];
let cartCount = 0;

// Cart elements
const cartIcon = document.getElementById('cartIcon');
const cartCountElement = document.getElementById('cartCount');
const cartModal = document.getElementById('cartModal');
const cartItems = document.getElementById('cartItems');
const cartTotal = document.getElementById('cartTotal');
const closeCart = document.getElementById('closeCart');
const clearCart = document.getElementById('clearCart');
const checkoutBtn = document.getElementById('checkoutBtn');

// Order modal elements
const orderModal = document.getElementById('orderModal');
const orderForm = document.getElementById('orderForm');
const closeOrder = document.getElementById('closeOrder');
const cancelOrder = document.getElementById('cancelOrder');

// Add to cart functionality
document.querySelectorAll('.add-to-cart-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        const tourName = this.getAttribute('data-tour');
        const tourPrice = parseInt(this.getAttribute('data-price'));
        
        addToCart(tourName, tourPrice);
        showNotification(`${tourName} добавлен в корзину!`);
    });
});

function addToCart(name, price) {
    const existingItem = cart.find(item => item.name === name);
    
    if (existingItem) {
        existingItem.quantity += 1;
    } else {
        cart.push({ name, price, quantity: 1 });
    }
    
    updateCartDisplay();
}

function updateCartDisplay() {
    cartCount = cart.reduce((total, item) => total + item.quantity, 0);
    cartCountElement.textContent = cartCount;
    
    if (cart.length === 0) {
        cartItems.innerHTML = `
            <div class="empty-cart">
                <i class="fas fa-shopping-cart"></i>
                <h3>Корзина пуста</h3>
                <p>Добавьте туры для оформления заказа</p>
            </div>
        `;
        cartTotal.textContent = '0';
    } else {
        cartItems.innerHTML = cart.map(item => `
            <div class="cart-item">
                <div class="cart-item-info">
                    <h4>${item.name}</h4>
                    <p>Количество: ${item.quantity}</p>
                </div>
                <div class="cart-item-price">${item.price * item.quantity} ₽</div>
                <button class="remove-item" onclick="removeFromCart('${item.name}')">&times;</button>
            </div>
        `).join('');
        
        const total = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
        cartTotal.textContent = total;
    }
}

function removeFromCart(name) {
    cart = cart.filter(item => item.name !== name);
    updateCartDisplay();
}

function showNotification(message) {
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #2c5530;
        color: white;
        padding: 15px 20px;
        border-radius: 8px;
        z-index: 10002;
        animation: slideIn 0.3s ease;
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
    `;
    notification.textContent = message;
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.remove();
    }, 3000);
}

// Event listeners for cart
cartIcon.addEventListener('click', () => {
    cartModal.classList.add('active');
});

closeCart.addEventListener('click', () => {
    cartModal.classList.remove('active');
});

clearCart.addEventListener('click', () => {
    cart = [];
    updateCartDisplay();
    showNotification('Корзина очищена');
});

checkoutBtn.addEventListener('click', () => {
    if (cart.length === 0) {
        showNotification('Корзина пуста!');
        return;
    }
    
    cartModal.classList.remove('active');
    orderModal.classList.add('active');
    updateOrderSummary();
});

closeOrder.addEventListener('click', () => {
    orderModal.classList.remove('active');
});

cancelOrder.addEventListener('click', () => {
    orderModal.classList.remove('active');
});

function updateOrderSummary() {
    const orderSummary = document.getElementById('orderSummary');
    const orderTotal = document.getElementById('orderTotal');
    
    orderSummary.innerHTML = cart.map(item => `
        <div class="order-item">
            <span>${item.name} x${item.quantity}</span>
            <span>${item.price * item.quantity} ₽</span>
        </div>
    `).join('');
    
    const total = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    orderTotal.textContent = total;
}

// Order form submission
orderForm.addEventListener('submit', function(e) {
    e.preventDefault();
    
    const formData = new FormData(this);
    const orderData = {
        customer: {
            name: formData.get('name'),
            phone: formData.get('phone'),
            email: formData.get('email')
        },
        tour: {
            date: formData.get('date'),
            participants: formData.get('participants'),
            requests: formData.get('requests')
        },
        items: cart,
        total: cart.reduce((sum, item) => sum + (item.price * item.quantity), 0)
    };
    
    // Simulate order processing
    showNotification('Заказ успешно оформлен! Мы свяжемся с вами в ближайшее время.');
    
    // Clear cart and close modals
    cart = [];
    updateCartDisplay();
    orderModal.classList.remove('active');
    this.reset();
});

// Close modals when clicking outside
cartModal.addEventListener('click', function(e) {
    if (e.target === this) {
        this.classList.remove('active');
    }
});

orderModal.addEventListener('click', function(e) {
    if (e.target === this) {
        this.classList.remove('active');
    }
});

// Initialize cart display
updateCartDisplay();
