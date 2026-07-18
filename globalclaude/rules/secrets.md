Never print, echo, log, or commit the contents of .env files, API keys, tokens,
private keys, or anything under a secrets/ directory. When a secret is needed,
reference the environment variable name only (e.g. SUPABASE_KEY), never its value.
If a task seems to require reading a secret, stop and ask instead.
