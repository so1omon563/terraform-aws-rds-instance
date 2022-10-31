# Create a random initial master password. Since TF stores this value in the tfstate file,
# it should be changed from this initial value outside of TF as soon as possible.
resource "random_string" "master_pw" {
  length           = 20
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  override_special = "!#$&*-=+:?"
}

# Generates a 2 byte random number that can be appended to the DB name to create a unique identifier.
resource "random_id" "db_identifier" {
  byte_length = 2
}
