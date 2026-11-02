// ربط الموقع بقاعدة البيانات (Supabase) - عدّل السطر التالي بالبيانات بتاعتك
(function () {
  if (!window.supabase) return;
  const sb = window.supabase.createClient('https://cnygozaqtomkprpeydgc.supabase.co', 'sb_publishable_--faLKzcgaevNrvutQuSZw_uuocJWRN');
  const $$ = s => document.querySelector(s);
  const esc = s => String(s ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

  async function get(table) {
    const { data, error } = await sb.from(table).select('*').eq('published', true).order('sort_order');
    if (error) { console.warn(table, error.message); return null; }
    return data;
  }

  // ترتيب المشاريع: الأحدث الأول (created_at، ولو مش موجود نرجع للـ id)
  function sortNewestFirst(a, b) {
    const ta = a.created_at ? new Date(a.created_at).getTime() : NaN;
    const tb = b.created_at ? new Date(b.created_at).getTime() : NaN;
    if (!Number.isNaN(ta) && !Number.isNaN(tb) && ta !== tb) return tb - ta;
    return String(b.id).localeCompare(String(a.id), undefined, { numeric: true });
  }

  async function run() {
    const [pr, pk, co, te, st] = await Promise.all([
      get('projects'), get('packages'), get('courses'), get('testimonials'),
      sb.from('site_settings').select('*')
    ]);

    // المشاريع (معرض الأعمال) - الأحدث الأول + علامة "جديد" تلقائياً للأحدث
    if (pr) {
      const sorted = pr.slice().sort(sortNewestFirst);
      projectsData = sorted.map((p, i) => ({
        id: p.id,
        title: p.title,
        category: p.category,
        coverImage: p.cover_image,
        isNew: i === 0 ? true : !!p.is_new, // الأحدث دايماً عليه علامة "جديد"
        gallery: p.gallery || []
      }));
      renderHomeProjects(projectsData);
    }

    // الباكجات
    if (pk) {
      $$('.packages-container').innerHTML = pk.map(p => `
        <div class="pricing-card tilt-effect">
          ${p.discount_label ? `<div class="discount-badge">${esc(p.discount_label)}</div>` : ''}
          <h3 class="package-title">${esc(p.title)}</h3>
          <div class="package-price"><span class="current-price">${esc(p.price)}</span> <span class="currency">ج.م</span>${p.old_price ? ` <span class="old-price">${esc(p.old_price)} ج.م</span>` : ''}</div>
          <button class="package-details-btn" onclick="togglePackageDetails(this)"><span>تفاصيل الباقة</span> <i class="fas fa-chevron-down"></i></button>
          <div class="package-details-content"><ul>${(p.features || []).map(f => `<li><i class="fas fa-check-circle"></i> ${esc(f)}</li>`).join('')}</ul></div>
          <button class="order-btn magnetic">اطلب الباقة الآن <i class="fas fa-arrow-left"></i></button>
        </div>`).join('');
      document.querySelectorAll('.packages-container .order-btn').forEach((b, i) => b.onclick = () => openPackageModal(pk[i].title, pk[i].price));
      init3DTilt();
    }

    // الكورسات
    if (co) {
      document.querySelectorAll('#view-courses .course-card').forEach(el => el.remove());
      $$('#view-courses').insertAdjacentHTML('beforeend', co.map(c => `
        <div class="course-card tilt-effect">
          <div class="course-image-container">${c.discount_label ? `<div class="course-discount-badge">${esc(c.discount_label)}</div>` : ''}<img src="${esc(c.image)}" alt="${esc(c.title)}"></div>
          <div class="course-content">
            <h3 class="course-title">${esc(c.title)}</h3>
            <p class="course-desc">${esc(c.description)}</p>
            <ul class="course-features">${(c.features || []).map(f => `<li><i class="fas fa-check-circle"></i> ${esc(f)}</li>`).join('')}</ul>
            <h4 style="margin-bottom:10px;color:var(--text-white)">محتوى الكورس:</h4>
            <div class="course-modules">${(c.modules || []).map(m => `<button class="module-btn">${esc(m.title)} <i class="fas fa-chevron-down"></i></button><div class="module-content">${(m.lessons || []).map(l => `<p>- ${esc(l)}</p>`).join('')}</div>`).join('')}</div>
            <div class="package-price" style="margin-top:20px"><span class="current-price">${esc(c.price)}</span> <span class="currency">ج.م</span>${c.old_price ? ` <span class="old-price">${esc(c.old_price)} ج.م</span>` : ''}</div>
            <button class="order-btn magnetic">احجز مكانك الآن <i class="fas fa-arrow-left"></i></button>
          </div>
        </div>`).join(''));
      document.querySelectorAll('#view-courses .course-card').forEach((card, i) => {
        card.querySelector('.order-btn').onclick = () => openEnrollModal(co[i].title);
        card.querySelectorAll('.module-btn').forEach(b => b.onclick = function () {
          this.classList.toggle('active');
          const panel = this.nextElementSibling;
          panel.style.maxHeight = panel.style.maxHeight ? null : panel.scrollHeight + 'px';
        });
      });
    }

    // آراء العملاء
    if (te) {
      $$('.testimonials-wrapper').innerHTML = te.map(t => `
        <div class="testimonial-card">
          <i class="fas fa-quote-right"></i>
          <p class="testimonial-text">"${esc(t.body)}"</p>
          <div class="testimonial-author">
            <div class="testimonial-avatar">${esc(t.name).charAt(0)}</div>
            <div><div class="testimonial-name">${esc(t.name)}</div><div class="testimonial-role">${esc(t.role)}</div></div>
          </div>
        </div>`).join('');
    }

    // الإعدادات (نصوص وروابط التواصل)
    const s = Object.fromEntries((st.data || []).map(r => [r.key, r.value]));
    if (s.hero_desc) $$('.hero-desc').textContent = s.hero_desc;
    if (s.journey_text) $$('.journey-text').textContent = s.journey_text;
    if (s.whatsapp) document.querySelectorAll('a[href*="wa.me/"]').forEach(a => a.href = 'https://wa.me/' + s.whatsapp);
    if (s.phone) document.querySelectorAll('a[href^="tel:"]').forEach(a => a.href = 'tel:+' + s.phone);
    if (s.email) document.querySelectorAll('a[href^="mailto:"]').forEach(a => a.href = 'mailto:' + s.email);
    if (s.email) document.querySelectorAll('a[href^="mailto:"] small').forEach(e => e.textContent = s.email);
    if (s.phone) document.querySelectorAll('a[href^="tel:"] small').forEach(e => e.textContent = '+' + s.phone);
    const social = { 'فيسبوك': 'facebook', 'انستجرام': 'instagram', 'بيهانس': 'behance', 'لينكد إن': 'linkedin' };
    Object.entries(social).forEach(([title, key]) => {
      const a = document.querySelector(`a[title="${title}"]`);
      if (a && s[key]) a.href = s[key];
    });
  }

  run().catch(e => console.warn('CMS error', e));
})();