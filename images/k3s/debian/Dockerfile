FROM ghcr.io/ofskills/debian:latest

COPY k3s/ansible.yaml ansible.yaml
RUN ansible-playbook -i localhost, ansible.yaml -c local && \
    rm ansible.yaml
