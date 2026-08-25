FROM alpine:3.19

# 安装 Python 与 pip（不再依赖 python:3.11-alpine 镜像）
RUN apk add --no-cache python3 py3-pip

WORKDIR /app
COPY requirements.txt .
RUN pip3 install --no-cache-dir --break-system-packages -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["python3", "backend/app.py"]
