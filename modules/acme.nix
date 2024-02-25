{...}: let
  admin_email = "dino@dinoocch.dev";
in
{
  # Configure automated TLS acquisition/renewal
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = admin_email;
    };
  };

  # ACME data must be readable by the NGINX user
  users.users.nginx.extraGroups = [
    "acme"
  ];
}
