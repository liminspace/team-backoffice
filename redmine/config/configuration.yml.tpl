default:
  email_delivery:
    delivery_method: :smtp
    smtp_settings:
      address: "${NETWORK_HOST_IP}"
      port: 25
