# AI 水印去除工具

去除主流 AI 图片生成平台水印的 Web 工具，去除后图片保持自然清晰。

## 支持平台

- ChatGPT / DALL-E
- Midjourney
- Stable Diffusion
- 文心一格
- 通义万相
- Gemini / Imagen（含 SynthID 不可见水印）

## 技术栈

- **前端：** React + TypeScript + Tailwind CSS + Vite
- **后端：** Python + FastAPI + OpenCV + LaMa (PyTorch)
- **部署：** Docker Compose

## 快速开始

### Docker 部署（推荐）

```bash
# 克隆项目
git clone <repo-url>
cd ai-watermark-remover

# 一键启动
docker-compose up --build
```

访问 http://localhost 即可使用。

### 本地开发

**后端：**

```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

**前端：**

```bash
cd frontend
npm install
npm run dev
```

访问 http://localhost:3000

### LaMa 模型权重

默认使用 OpenCV 内置 inpainting 作为 fallback。如需使用 LaMa 模型获得更好效果：

1. 从 https://github.com/advimman/lama 下载预训练权重
2. 将权重文件放到 `backend/weights/lama/best.ckpt`

## API 接口

| 方法   | 路径                  | 说明             |
| ---- | ------------------- | -------------- |
| POST | `/api/detect`       | 上传图片，检测水印位置    |
| POST | `/api/remove`       | 上传图片，去除水印并返回结果 |
| POST | `/api/batch/remove` | 批量上传图片，批量去水印   |
| GET  | `/health`           | 健康检查           |

## 项目结构

```
ai-watermark-remover/
├── frontend/          # React 前端
│   ├── src/
│   │   ├── components/
│   │   │   ├── UploadZone.tsx    # 拖拽上传
│   │   │   ├── CompareSlider.tsx # 前后对比滑块
│   │   │   └── BatchList.tsx     # 批量处理列表
│   │   ├── services/api.ts       # API 封装
│   │   ├── App.tsx               # 主应用
│   │   └── main.tsx              # 入口
│   └── Dockerfile
├── backend/           # Python 后端
│   ├── app/
│   │   ├── core/
│   │   │   ├── detector.py       # 水印检测
│   │   │   ├── inpainter.py      # LaMa 修复
│   │   │   ├── synthid.py        # SynthID 处理
│   │   │   └── postprocess.py    # 后处理增强
│   │   ├── api/routes.py         # API 路由
│   │   ├── models/schemas.py     # 数据模型
│   │   └── main.py               # FastAPI 入口
│   ├── weights/                   # 模型权重
│   ├── requirements.txt
│   └── Dockerfile
├── docker-compose.yml
└── README.md
```
