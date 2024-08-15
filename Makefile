.PHONY: all
all: up route

# Bring up the services
.PHONY: up
up:
	@docker compose up -d

# Install packages & Set up the network routes
.PHONY: route
route:
	@echo "Please wait..."
	@sleep 60
	@echo "Configuring APISIX container..."
	@docker compose exec --user root apisix bash -c 'apt update && apt install -y iproute2 && ip route add 198.51.100.0/24 via 172.20.0.10' || true
	@echo "Configuring Nikto container..."
	@docker compose exec --user root nikto sh -c 'apk add -u curl && ip route add 172.20.0.0/24 via 198.51.100.10' || true

# Clean up the services and volumes
.PHONY: down
down:
	@docker compose down -v
