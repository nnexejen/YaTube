# yatube/Dockerfile (Multi-stage, non-root, healthcheck)
FROM python:3.9-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

FROM python:3.9-slim

WORKDIR /app

# Создаём непривилегированного пользователя
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

COPY --from=builder /root/.local /home/appuser/.local
COPY --chown=appuser:appuser . .

ENV PATH="/home/appuser/.local/bin:$PATH"
EXPOSE 8000

# Healthcheck для Kubernetes/Docker
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/')" || exit 1

CMD ["gunicorn", "yatube.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "2", "--log-level", "info"]