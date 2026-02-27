resource "pocketid_group" "family" {
  name          = "family"
  friendly_name = "Family"
}

resource "pocketid_client" "home-assistant" {
  name      = "home-assistant"
  is_public = true

  callback_urls = [
    var.home_assistant_redirect_uri,
  ]

  allowed_user_groups = [
    pocketid_group.family.id,
  ]
}
