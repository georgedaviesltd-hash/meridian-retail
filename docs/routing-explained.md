# Meridian Retail Nginx Routing Strategy

## Overview
This document explains the Nginx reverse proxy routing configuration (`nginx/meridian-http.conf`) for the Meridian Retail Group microservices platform.

## Routing Architecture

1. **Root Path (`/`)**
   - Routes to the Frontend container running on `127.0.0.1:8080`.
   - Serves the storefront web interface to end users.

2. **Auth Service (`/api/auth/*`)**
   - Routes to the Auth Service running on `127.0.0.1:8001`.
   - `/api/auth/healthz` maps to `/healthz` on the Auth container for health checking.
   - Handles user registration, login, and JWT token issuance/verification.

3. **Catalog Service (`/api/catalog/*`)**
   - Routes to the Catalog Service running on `127.0.0.1:8002`.
   - `/api/catalog/healthz` maps to `/healthz` on the Catalog container.
   - Handles product catalog listing and details.

4. **Orders Service (`/api/orders*`)**
   - Routes to the Orders Service running on `127.0.0.1:8003`.
   - `/api/orders/healthz` maps to `/healthz` on the Orders container.
   - Handles order placement and order history fetching.

## Header Forwarding
All proxy blocks include standard headers (`Host`, `X-Real-IP`, `X-Forwarded-For`, `X-Forwarded-Proto`) to preserve original client request metadata across the reverse proxy.
