FROM quay.io/keycloak/keycloak:26.0.0 AS builder

WORKDIR /opt/keycloak
# COPY --from=keycloakify_jar_builder /opt/app/build_keycloak/target/ keycloakify-starter-keycloak-theme-5.1.3.jar /opt/keycloak/providers/
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:26.0.0
COPY --from=builder /opt/keycloak/ /opt/keycloak/

COPY dokku-kc.sh /opt/keycloak/bin

RUN chmod +x /opt/keycloak/bin/dokku-kc.sh
ENTRYPOINT ["/opt/keycloak/bin/dokku-kc.sh"]