FROM quay.io/keycloak/keycloak:26.0.0 AS builder

WORKDIR /opt/keycloak
# COPY --from=keycloakify_jar_builder /opt/app/build_keycloak/target/ keycloakify-starter-keycloak-theme-5.1.3.jar /opt/keycloak/providers/
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:26.0.0
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Copy the script to a different directory where we have permission
COPY dokku-kc.sh /usr/local/bin/

# Ensure the script is executable
RUN chmod +x /usr/local/bin/dokku-kc.sh

# Set ENTRYPOINT to use the customized script
ENTRYPOINT ["/usr/local/bin/dokku-kc.sh"]