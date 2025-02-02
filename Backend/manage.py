import os
import sys
from tasks.scheduler import start_scheduler
from apscheduler.schedulers.background import BackgroundScheduler


def main():

    scheduler = BackgroundScheduler()
    start_scheduler(scheduler)
    scheduler.start()

    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'Backend.settings')
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc
    execute_from_command_line(sys.argv)


if __name__ == '__main__':
    main()
