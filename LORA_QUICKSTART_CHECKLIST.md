# LoRA Training Quick Start Checklist
## Get Your Badge Style LoRA Running Today

**Goal:** Train a LoRA model for consistent Lebanese memorial badge icons
**Time:** 3-4 hours total
**Cost:** $2-3 (RunPod cloud GPU)

---

## ✅ **PHASE 1: Collect Training Images (30-60 minutes)**

### **What You Need:**
15-30 images of badge/icon designs that match your desired style

### **Image Search Keywords:**

#### **Search on Google Images:**
```
- "memorial badge icon flat design"
- "heritage foundation logo minimalist"
- "museum achievement badge"
- "dignified icon design memorial"
- "cultural preservation badge"
- "cedar tree icon flat design"
- "olive branch icon minimalist"
- "Lebanese cultural emblem"
- "achievement badge flat style"
- "historical society icon design"
```

#### **Search on Design Sites:**

**Dribbble:**
- https://dribbble.com/search/memorial-badge
- https://dribbble.com/search/heritage-icon
- https://dribbble.com/search/flat-badge-design

**Behance:**
- https://www.behance.net/search/projects?search=memorial+icon
- https://www.behance.net/search/projects?search=cultural+badge

**The Noun Project:**
- https://thenounproject.com/search/?q=cedar+tree
- https://thenounproject.com/search/?q=memorial+badge
- https://thenounproject.com/search/?q=heritage

**Flaticon (Premium):**
- https://www.flaticon.com/search?word=memorial
- https://www.flaticon.com/search?word=badge

#### **Museum/Heritage Websites:**
```
- Smithsonian badges/emblems
- Louvre cultural programs
- UNESCO heritage logos
- National park badges (US/Canada)
- Lebanese cultural organizations
- Middle Eastern heritage foundations
```

### **What Makes a GOOD Training Image:**

✅ **YES - Use These:**
- Flat, minimalist icon design
- Circular or badge-shaped composition
- Clean background (white, transparent, or solid color)
- Memorial/dignified aesthetic (NOT playful)
- Cultural symbols (trees, geometric patterns, architectural elements)
- Achievement badges from serious apps
- Museum/heritage logos
- Lebanese cultural elements (cedar, olive, traditional patterns)

❌ **NO - Avoid These:**
- Photorealistic images
- Complex backgrounds
- Cartoon/playful game badges
- Low resolution (under 512px)
- Text-heavy designs
- War/weapon imagery

### **Image Quality Requirements:**
```
Resolution: At least 512x512px (preferably 768px or higher)
Format: PNG or JPG
Background: White, transparent, or solid color (NOT complex scenes)
Count: Minimum 15, ideal 20-30
```

---

## 📁 **PHASE 2: Prepare Your Dataset (30 minutes)**

### **Step 2.1: Create Training Folder**

Create this folder structure on your computer:
```
C:\Users\ziadf\Documents\Projects\UNDP\lora_training\
├── training_images\
│   ├── 001_memorial_badge_cedar.png
│   ├── 002_heritage_icon_olive.png
│   ├── 003_flat_achievement.png
│   └── ... (15-30 images)
└── output\
```

### **Step 2.2: Download and Prepare Images**

For each image you download:

**Option A: Manual Preparation (Free)**
1. **Download** the image
2. **Crop to square** (1:1 ratio):
   - Windows: Use Paint or Photos app
   - Online: https://www.iloveimg.com/crop-image
3. **Resize to 768x768px**:
   - Online: https://www.iloveimg.com/resize-image
   - Set to 768x768, maintain quality
4. **Clean background** if needed:
   - remove.bg (https://remove.bg) - 50 free/month
   - Or keep white/solid backgrounds
5. **Save as PNG** in `training_images\` folder
6. **Rename** with descriptive name:
   ```
   001_memorial_cedar_badge.png
   002_heritage_olive_icon.png
   003_museum_achievement.png
   004_lebanese_cultural_emblem.png
   ```

**Option B: Bulk Tools (Faster)**
- **Bulk resize:** https://bulkresizephotos.com
- **Background removal:** https://www.remove.bg
- **Crop to square:** https://www.iloveimg.com/crop-image

### **Step 2.3: Create Caption Files**

For EACH image, create a `.txt` file with the SAME name:

**Example:**
```
Image: 001_memorial_cedar_badge.png
Text file: 001_memorial_cedar_badge.txt
```

**What to write in the .txt file:**
```
a dignified memorial badge icon, flat design, warm earthy colors,
circular composition, Lebanese cultural elements, cedar tree motif,
minimalist style, clean background
```

**Caption Template (copy this for each image):**
```
a dignified memorial badge icon, flat design, [color description],
circular composition, Lebanese cultural elements, [main symbol like
cedar/olive/geometric pattern], minimalist style, [additional details]
```

**Quick Caption Examples:**
```
File: 002_heritage_olive.txt
Caption: a dignified memorial badge icon, flat design, olive green tones,
circular composition, Lebanese olive branch motif, heritage preservation
aesthetic, minimalist style, clean background

File: 003_achievement_flat.txt
Caption: a dignified memorial badge icon, flat design, gold and blue colors,
circular composition, achievement symbol, minimalist style, clean background,
professional icon design
```

### **Checklist Before Moving to Step 3:**
- [ ] 15-30 images downloaded
- [ ] All images cropped to square (1:1 ratio)
- [ ] All images resized to 768x768px
- [ ] All images saved as PNG in `training_images\` folder
- [ ] Each image has a matching `.txt` caption file
- [ ] Captions describe style, colors, Lebanese elements

---

## 🖥️ **PHASE 3: Setup Cloud GPU Training (20 minutes)**

### **Why Cloud GPU?**
- No local GPU needed
- Faster training (RTX 4090 vs your GPU)
- Cost: Only $2-3 for one training session
- Professional results

### **Option A: RunPod (Recommended - Easy)**

**Step 3.1: Create RunPod Account**
1. Go to https://runpod.io
2. Click "Sign Up"
3. Add payment method (credit card)
4. Add $10 credit (you'll only use $2-3)

**Step 3.2: Deploy GPU Pod**
1. Click "Deploy" → "GPU Pods"
2. **Filter by GPU:** Select "RTX 4090" or "RTX A6000"
3. **Select Template:** Search for "Kohya SS" or "LoRA Trainer"
   - If not available, select "RunPod PyTorch"
4. **Choose Region:** US or EU (cheapest available)
5. **Disk Space:** 50GB
6. **Click "Deploy"**
7. **Cost:** ~$0.60-0.80/hour (you'll need 2-3 hours max)

**Step 3.3: Access Your Pod**
1. Wait for pod to start (2-5 minutes)
2. Click "Connect" → "Jupyter Lab" or "HTTP Service"
3. Opens in browser (looks like a file manager)

**Step 3.4: Upload Training Images**
1. In Jupyter interface, create folder: `lora_training`
2. Upload all images from `training_images\` folder
3. Upload all `.txt` caption files too

---

### **Option B: Civitai (Easiest - Automated, but $10-30)**

**Step 3.1: Create Civitai Account**
1. Go to https://civitai.com
2. Sign up (free)
3. Go to https://civitai.com/models/train

**Step 3.2: Upload Images**
1. Click "New LoRA Training"
2. Upload your 15-30 images + captions
3. Name your LoRA: "lebanese_memorial_badges"
4. **Base Model:** Select "SDXL 1.0" (best quality)
5. **Training Steps:** 2000
6. Click "Start Training"
7. **Cost:** $10-30 (auto-charged)

**Step 3.3: Wait**
- Training takes 1-3 hours
- You'll get email when done
- Download `.safetensors` file

**Skip to Phase 5 if using Civitai**

---

## ⚙️ **PHASE 4: Configure & Train LoRA (RunPod Only - 15 minutes setup + 2-3 hours training)**

### **Step 4.1: Install Kohya SS (if not pre-installed)**

If you selected RunPod PyTorch (not Kohya SS template):

Open terminal in Jupyter and run:
```bash
git clone https://github.com/bmaltais/kohya_ss.git
cd kohya_ss
pip install -r requirements.txt
```

### **Step 4.2: Launch Kohya SS GUI**

In terminal:
```bash
cd kohya_ss
python gui.py --share
```

Copy the URL (looks like: `http://127.0.0.1:7860`) and open in browser

### **Step 4.3: Configure Training**

In Kohya SS interface:

**LoRA Tab → Settings:**

```
Model:
- Base Model: stabilityai/stable-diffusion-xl-base-1.0 (SDXL)
  OR: runwayml/stable-diffusion-v1-5 (SD 1.5 - faster)

Folders:
- Image folder: /workspace/lora_training/training_images
- Output folder: /workspace/lora_training/output
- Logging folder: /workspace/lora_training/logs

Network Settings:
- Network Rank (Dimension): 32
- Network Alpha: 16
- Network Type: LoRA

Training Settings:
- Learning Rate: 0.0001
- Text Encoder LR: 0.00005
- Unet LR: 0.0001
- LR Scheduler: constant
- Optimizer: AdamW8bit

Steps & Saving:
- Max Training Steps: 2000
- Save Every N Steps: 500
- Keep N Saved Models: 4

Batch & Resolution:
- Batch Size: 1
- Train Resolution: 1024 (SDXL) or 512 (SD 1.5)
- Enable Bucket: Yes
- Min/Max Bucket Resolution: 768-1024

Advanced:
- Mixed Precision: fp16
- Cache Latents: Yes
- Gradient Checkpointing: Yes
```

### **Step 4.4: Start Training**

1. Double-check all paths are correct
2. Click **"Train"** button at bottom
3. Training starts (2-3 hours)
4. Watch progress in terminal/logs

**You'll get 4 checkpoint files:**
```
lebanese_badge_style_500.safetensors
lebanese_badge_style_1000.safetensors
lebanese_badge_style_1500.safetensors
lebanese_badge_style_2000.safetensors (final)
```

### **Step 4.5: Download LoRA Files**

1. Go to output folder in Jupyter
2. Download all `.safetensors` files
3. Save to your computer:
   ```
   C:\Users\ziadf\Documents\Projects\UNDP\lora_models\
   ```

### **Step 4.6: Stop GPU Pod (IMPORTANT!)**

**⚠️ DON'T FORGET THIS - COSTS MONEY!**

1. Go back to RunPod dashboard
2. Find your pod
3. Click **"Stop"** or **"Terminate"**
4. Confirm termination
5. **Check your billing** - should be $2-3 total

---

## 🎨 **PHASE 5: Install Stable Diffusion & Test LoRA (30 minutes)**

### **Step 5.1: Install Automatic1111 WebUI**

**Windows:**

1. **Install Git:**
   - Download: https://git-scm.com/download/win
   - Install with default settings

2. **Install Python 3.10:**
   - Download: https://www.python.org/downloads/release/python-31011/
   - ⚠️ Check "Add Python to PATH" during installation

3. **Download Stable Diffusion WebUI:**
   - Open Command Prompt (Win + R → `cmd`)
   - Navigate to folder:
     ```cmd
     cd C:\Users\ziadf\Documents\Projects\UNDP
     ```
   - Clone repository:
     ```cmd
     git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
     ```

4. **Download Base Model:**
   - Go to: https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/tree/main
   - Download: `sd_xl_base_1.0.safetensors` (6.9GB)
   - Place in: `stable-diffusion-webui\models\Stable-diffusion\`

5. **Run WebUI:**
   ```cmd
   cd stable-diffusion-webui
   webui-user.bat
   ```
   - First run takes 5-10 minutes (downloads dependencies)
   - Opens in browser: `http://127.0.0.1:7860`

### **Step 5.2: Add Your LoRA**

1. Copy your trained LoRA file:
   ```
   From: C:\Users\ziadf\Documents\Projects\UNDP\lora_models\lebanese_badge_style_2000.safetensors
   To: stable-diffusion-webui\models\Lora\
   ```

2. Refresh Automatic1111 (click refresh button next to "Lora" tab)

### **Step 5.3: Test Generate First Badge**

In Automatic1111 WebUI:

**Prompt:**
```
<lora:lebanese_badge_style_2000:1.0> a dignified memorial badge icon,
stylized microphone with sound waves, pink and red colors, Lebanese cedar
leaf accent, flat design, circular composition, minimalist style,
transparent background, professional icon design
```

**Negative Prompt:**
```
photorealistic, 3d render, text, letters, watermark, signature,
complex background, war imagery, weapons, cartoonish
```

**Settings:**
```
Sampling Steps: 40
Sampler: DPM++ 2M Karras
CFG Scale: 7
Width: 1024
Height: 1024
Batch Count: 4 (generates 4 variations)
```

**Click "Generate"**

### **Step 5.4: Evaluate Results**

✅ **Good LoRA produces:**
- Consistent memorial style across images
- Clean, flat design aesthetic
- Recognizable Lebanese cultural elements
- Colors match prompt
- Sharp edges, good for icons

❌ **Poor results? Try:**
- Adjust LoRA strength: `<lora:name:0.8>` or `<lora:name:1.2>`
- Use different checkpoint (try 1500 instead of 2000)
- Adjust CFG scale (try 5-9)
- Add more negative prompts

### **Step 5.5: Generate All 12 Badges**

Once first test looks good, generate the rest:

**Voice Badge:** ✅ (already tested)

**Witness Badge:**
```
<lora:lebanese_badge_style_2000:1.0> a dignified memorial badge icon,
stylized camera with photo frame, purple and lavender colors, Lebanese
geometric pattern border, flat design, circular composition, minimalist style
```

**Memory Keeper Badge:**
```
<lora:lebanese_badge_style_2000:1.0> a dignified memorial badge icon,
eternal flame in protective lantern, warm gold and yellow colors, Lebanese
cedar tree silhouette background, flat design, circular composition
```

...and so on for all 12 badges using the prompts from `BADGE_ICON_AI_PROMPTS.md`

---

## ⏱️ **Timeline Summary**

| Phase | Time | Cost |
|-------|------|------|
| Collect images | 30-60 min | Free |
| Prepare dataset | 30 min | Free |
| Setup cloud GPU | 20 min | Free |
| Train LoRA | 2-3 hours | $2-3 |
| Install SD + Test | 30 min | Free |
| **TOTAL** | **4-5 hours** | **$2-3** |

---

## 📋 **Quick Checklist**

**Today - Preparation:**
- [ ] Collect 15-30 reference images
- [ ] Crop and resize to 768x768px
- [ ] Create caption .txt files for each image
- [ ] Sign up for RunPod account
- [ ] Add $10 credit to RunPod

**Tomorrow - Training:**
- [ ] Deploy GPU pod on RunPod
- [ ] Upload training images
- [ ] Configure Kohya SS settings
- [ ] Start training (2-3 hours)
- [ ] Download trained LoRA files
- [ ] **STOP GPU POD!** (critical!)

**Day 3 - Testing:**
- [ ] Install Automatic1111 WebUI
- [ ] Download SDXL base model
- [ ] Add LoRA to models folder
- [ ] Test generate first badge
- [ ] Generate all 12 badges
- [ ] Post-process and resize

---

## 🆘 **Quick Help**

**"Where do I find good reference images?"**
→ Search Dribbble, Noun Project, museum websites (see Phase 1)

**"I don't have a GPU"**
→ That's why we're using RunPod cloud GPU ($2-3)

**"Training failed"**
→ Check paths are correct, reduce batch size to 1, try again

**"LoRA creates blurry images"**
→ Use SDXL base model (not SD 1.5), increase resolution to 1024

**"Forgot to stop RunPod!"**
→ Go to dashboard NOW and terminate pod

---

## 🎯 **What You Get**

After completing this:
✅ Custom LoRA trained on your style
✅ Ability to generate unlimited consistent badges
✅ Perfect style matching across all 12 badges
✅ Reusable for future badge/icon needs
✅ Knowledge of LoRA training for other projects

---

**Ready to start? Begin with Phase 1 - collect those reference images!** 🚀

Let me know when you have images collected and I'll help with the next step!
