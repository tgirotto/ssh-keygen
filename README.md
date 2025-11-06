# SSH Keygen Docker Module

Generates SSH key pairs using Docker - equivalent to `ssh-keygen` command.

## Usage

The module expects a JSON array with the SSH keygen configuration as the first element.

### RSA Key (4096 bits) - equivalent to `ssh-keygen -t rsa -b 4096 -C "email@example.com"`
```json
[{
  "t": "rsa",
  "b": 4096,
  "C": "tommaso.girotto91@gmail.com"
}]
```

### Ed25519 Key - equivalent to `ssh-keygen -t ed25519 -C "email@example.com"`
```json
[{
  "t": "ed25519",
  "C": "tommaso.girotto91@gmail.com"
}]
```

### RSA Key (2048 bits) - equivalent to `ssh-keygen -t rsa -b 2048`
```json
[{
  "t": "rsa",
  "b": 2048
}]
```

### Raw Output Format (for direct use)
```json
[{
  "t": "rsa",
  "b": 2048,
  "C": "test@example.com",
  "raw": true
}]
```

## Output Formats

### JSON Format (Default)
Returns a JSON array with properly escaped keys:

```json
[
  "-----BEGIN OPENSSH PRIVATE KEY-----\n...\n-----END OPENSSH PRIVATE KEY-----\n",
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQ... tommaso.girotto91@gmail.com"
]
```

### Raw Format (with `"raw": true`)
Returns keys with actual newlines for direct use:

```
PRIVATE_KEY:
-----BEGIN OPENSSH PRIVATE KEY-----
[actual key with real newlines]
-----END OPENSSH PRIVATE KEY-----
PUBLIC_KEY:
ssh-rsa [actual key with real newlines]
```

## Build

```bash
# Build the Docker image
docker build -t ssh-keygen .

```
docker save -o ssh-keygen.tar ssh-keygen
zip -9 artifact.zip ssh-keygen.tar
rm ssh-keygen.tar
```

# Test JSON format (default)
echo '[{"t": "rsa", "b": 2048, "C": "test@example.com"}]' | docker run -i ssh-keygen

# Test raw format (for direct use)
echo '[{"t": "rsa", "b": 2048, "C": "test@example.com", "raw": true}]' | docker run -i ssh-keygen
```

## Features

- ✅ RSA key generation (2048, 4096 bits)
- ✅ Ed25519 key generation
- ✅ OpenSSH format public keys
- ✅ OpenSSH format private keys
- ✅ Custom comments
- ✅ Docker for cross-platform compatibility
- ✅ Uses real ssh-keygen command for reliability
- ✅ Dual output formats (JSON for programmatic use, Raw for direct use)
- ✅ No external dependencies required