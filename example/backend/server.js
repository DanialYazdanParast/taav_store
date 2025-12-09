const fs = require('fs'); // برای مدیریت فایل‌ها و پوشه‌ها
const path = require('path');
const jsonServer = require('json-server');
const multer = require('multer');
const cors = require('cors');

const server = jsonServer.create();
const router = jsonServer.router('db.json');

// تنظیم پوشه استاتیک روی public (تا عکس‌ها از مرورگر باز شوند)
const middlewares = jsonServer.defaults({ static: './public' });

// ۱. فعال‌سازی CORS برای اجازه دسترسی به فلاتر
server.use(cors());
server.use(middlewares);
server.use(jsonServer.bodyParser);

// ۲. تنظیمات ذخیره‌سازی عکس با Multer
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    // مسیر ذخیره عکس‌ها: public/images
    const dir = './public/images';
    
    // اگر پوشه نبود، آن را بساز
    if (!fs.existsSync(dir)){
        fs.mkdirSync(dir, { recursive: true });
    }
    
    cb(null, dir);
  },
  filename: function (req, file, cb) {
    // نام فایل: زمان فعلی + پسوند اصلی (برای جلوگیری از تکرار)
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({ storage: storage });

// ۳. اندپوینت اختصاصی برای ثبت محصول (POST /products)
// این قسمت قبل از router اصلی قرار می‌گیرد تا درخواست را رهگیری کند
server.post('/products', upload.single('image'), (req, res) => {
  try {
    const db = router.db;
    const productData = req.body;
    
    let imageUrl = '';
    if (req.file) {
      const protocol = req.protocol;
      const host = req.get('host');
      imageUrl = `${protocol}://${host}/images/${req.file.filename}`;
    }

    let colors = [];
    let tags = [];
    try {
        if (productData.colors) colors = JSON.parse(productData.colors);
        if (productData.tags) tags = JSON.parse(productData.tags);
    } catch (e) { console.error(e); }

    const newProduct = {
      id: Date.now().toString(),
      ...productData,
      
      // ✅ تغییرات مهم اینجاست: تبدیل رشته به عدد
      price: Number(productData.price), 
      quantity: Number(productData.quantity), // نام فیلد quantity شد
      discountPrice: Number(productData.discountPrice || 0), // نام فیلد discountPrice شد (کمل کیس)
      
      image: imageUrl,
      colors: colors,
      tags: tags,
    };

    // حذف فیلدهای اضافه که ممکن است از FormData آمده باشند
    delete newProduct.count; // اگر count اشتباهی آمده پاک شود

    db.get('products').push(newProduct).write();
    res.status(201).json(newProduct);

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});


// ۴. اندپوینت اختصاصی برای ویرایش محصول (PUT /products/:id)
server.put('/products/:id', upload.single('image'), (req, res) => {
  try {
    const db = router.db;
    const { id } = req.params;
    const productData = req.body;

    // ۱. پیدا کردن محصول قدیمی
    const existingProduct = db.get('products').find({ id: id }).value();

    if (!existingProduct) {
      return res.status(404).json({ error: "Product not found" });
    }

    // ۲. مدیریت عکس: اگر عکس جدید آمد آپلود کن، اگر نه عکس قبلی را نگه دار
    let imageUrl = existingProduct.image; // پیش‌فرض: عکس قبلی
    if (req.file) {
      const protocol = req.protocol;
      const host = req.get('host');
      imageUrl = `${protocol}://${host}/images/${req.file.filename}`;
    }

    // ۳. پارس کردن آرایه‌ها (رنگ و تگ)
    let colors = existingProduct.colors; // پیش‌فرض: دیتای قبلی
    let tags = existingProduct.tags;

    try {
        if (productData.colors) colors = JSON.parse(productData.colors);
        if (productData.tags) tags = JSON.parse(productData.tags);
    } catch (e) { console.error("Error parsing arrays:", e); }

    // ۴. ساخت آبجکت آپدیت شده
    const updatedProduct = {
      ...existingProduct, // حفظ فیلدهای سیستمی
      ...productData,     // جایگزینی دیتای متنی جدید
      
      // تبدیل عددها (بسیار مهم)
      price: productData.price ? Number(productData.price) : existingProduct.price,
      quantity: productData.quantity ? Number(productData.quantity) : existingProduct.quantity,
      discountPrice: productData.discountPrice ? Number(productData.discountPrice) : 0,

      image: imageUrl,
      colors: colors,
      tags: tags,
    };

    // حذف فیلدهای اضافه
    delete updatedProduct.count; 

    // ۵. ذخیره در دیتابیس
    db.get('products').find({ id: id }).assign(updatedProduct).write();
    
    res.json(updatedProduct);

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

// استفاده از روتر پیش‌فرض برای سایر درخواست‌ها (GET, PUT, DELETE)
server.use(router);

server.listen(3000, () => {
  console.log('JSON Server is running on http://localhost:3000');
});