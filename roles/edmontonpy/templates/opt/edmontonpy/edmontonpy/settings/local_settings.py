DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': '{{ database_name }}',
        'USER': '{{ database_username }}',
        'PASSWORD': '{{ database_password }}',
        'HOST': '{{ groups['database'][0] }}',
    }
}

STATIC_ROOT = '/var/www/www.edmontonpy.com/static/'
