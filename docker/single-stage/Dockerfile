FROM python:3.12-slim

WORKDIR /app

RUN pip install --no-cache-dir requests

COPY app.py .

RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app

USER appuser

EXPOSE 8080

ENTRYPOINT ["python", "app.py"]

CMD []

