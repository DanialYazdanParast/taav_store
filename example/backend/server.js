const jsonServer = require('json-server');
const cors = require('cors');

const server = jsonServer.create();
const router = jsonServer.router('db.json');
const middlewares = jsonServer.defaults({ static: './public' });

server.use(cors());
server.use(middlewares);
server.use(jsonServer.bodyParser); // برای خواندن JSON

// اندپوینت اختصاصی برای ثبت محصول (POST /products)
server.post('/products', (req, res) => {
    try {
        const db = router.db;
        const productData = req.body;

        // 🔍 Debug: چاپ داده دریافتی
        console.log('📥 Received product data:');
        console.log('  Title:', productData.title);
        console.log('  Has imageBase64:', !!productData.imageBase64);
        console.log('  ImageBase64 length:', productData.imageBase64?.length || 0);
        console.log('  ImageBase64 first 50 chars:', productData.imageBase64?.substring(0, 50));

        // ✅ عکس را به صورت Base64 (بایت) نگه می‌داریم
        let imageData = '';
        
        if (productData.imageBase64) {
            // اگر رشته شامل هدر data:image است، همانطور نگه می‌داریم
            // اگر نیست، هدر را اضافه می‌کنیم تا در فرانت‌اند قابل نمایش باشد
            if (productData.imageBase64.startsWith('data:image')) {
                imageData = productData.imageBase64;
            } else {
                // فرض می‌کنیم فرمت PNG است - می‌توانید بر اساس نیاز تغییر دهید
                imageData = `data:image/png;base64,${productData.imageBase64}`;
            }
        }

        const newProduct = {
            id: Date.now().toString(),
            title: productData.title || '',
            description: productData.description || '',
            price: Number(productData.price) || 0,
            quantity: Number(productData.quantity) || 0,
            discountPrice: Number(productData.discountPrice) || 0,
            sellerId: productData.sellerId || '',
            colors: productData.colors || [], 
            tags: productData.tags || [],
            
            // ✅ ذخیره Base64 به جای URL
            image: imageData,
        };

        db.get('products').push(newProduct).write();
        res.status(201).json(newProduct);

    } catch (error) {
        console.error('Error creating product:', error);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

server.put('/products/:id', (req, res) => {
    try {
        const db = router.db;
        const { id } = req.params;
        const productData = req.body;

        // 🔍 Debug: چاپ داده دریافتی برای ویرایش
        console.log(`📥 Received update request for product ${id}:`);
        console.log('  Title:', productData.title);
        console.log('  Has imageBase64:', !!productData.imageBase64);
        console.log('  ImageBase64 length:', productData.imageBase64?.length || 0);

        // پیدا کردن محصول موجود
        const existingProduct = db.get('products').find({ id: id }).value();

        if (!existingProduct) {
            return res.status(404).json({ error: "Product not found" });
        }

        // مدیریت عکس:
        // ۱. اگر عکس جدید (Base64) ارسال شده باشد، آن را جایگزین می‌کنیم.
        // ۲. اگر عکس جدیدی ارسال نشده باشد، عکس قبلی را نگه می‌داریم.
        let finalImageData = existingProduct.image; // پیش‌فرض: عکس قبلی

        if (productData.imageBase64) {
            // اگر رشته شامل هدر data:image است، همانطور نگه می‌داریم
            // اگر نیست، هدر را اضافه می‌کنیم
            if (productData.imageBase64.startsWith('data:image')) {
                finalImageData = productData.imageBase64;
            } else {
                // فرض می‌کنیم فرمت PNG است (یا می‌توانید فرمت را هم از کلاینت بگیرید)
                finalImageData = `data:image/png;base64,${productData.imageBase64}`;
            }
        }

        const updatedProduct = {
            ...existingProduct, // حفظ فیلدهای سیستمی یا فیلدهایی که تغییر نکرده‌اند
            title: productData.title !== undefined ? productData.title : existingProduct.title,
            description: productData.description !== undefined ? productData.description : existingProduct.description,
            price: productData.price !== undefined ? Number(productData.price) : existingProduct.price,
            quantity: productData.quantity !== undefined ? Number(productData.quantity) : existingProduct.quantity,
            discountPrice: productData.discountPrice !== undefined ? Number(productData.discountPrice) : existingProduct.discountPrice,
            
            // رنگ‌ها و تگ‌ها (اگر ارسال نشده باشند، قبلی‌ها می‌مانند)
            colors: productData.colors || existingProduct.colors,
            tags: productData.tags || existingProduct.tags,

            // ✅ ذخیره عکس آپدیت شده (یا عکس قبلی)
            image: finalImageData,
        };

        // اعمال تغییرات در دیتابیس
        db.get('products').find({ id: id }).assign(updatedProduct).write();
        
        console.log(`✅ Product ${id} updated successfully.`);
        res.json(updatedProduct);

    } catch (error) {
        console.error('Error updating product:', error);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

// اندپوینت اختصاصی برای سبد خرید (POST /carts)
server.post('/carts', (req, res) => {
    try {
        const db = router.db;
        const cartData = req.body;

        const newCartItem = {
            id: Date.now().toString(),
            productId: cartData.productId || '',
            productTitle: cartData.productTitle || '',
            sellerId: cartData.sellerId || '',
            color: cartData.color || '',
            quantity: Number(cartData.quantity) || 1,
            price: Number(cartData.price) || 0,
            originalPrice: Number(cartData.originalPrice) || 0,
            
            // ✅ عکس به صورت Base64 ذخیره می‌شود
            image: cartData.image || '',
        };

        db.get('carts').push(newCartItem).write();
        res.status(201).json(newCartItem);

    } catch (error) {
        console.error('Error creating cart item:', error);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

server.use(router);

server.listen(3000, () => {
    console.log('JSON Server is running on http://localhost:3000');
});