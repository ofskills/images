FROM ghcr.io/ofskills/debian:latest

COPY k3s/ansible.yaml ansible.yaml
COPY kubernetes /opt/kubernetes
RUN ansible-playbook -i localhost, ansible.yaml -c local && \
    rm -rf ansible.yaml /opt/kubernetes
