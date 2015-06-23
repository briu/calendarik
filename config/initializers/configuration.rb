FULLCALENDAR_СUSTOM_SETTINGS_FILE_PATH = Rails.root.join('config', 'calendarik.yml')
custom_config = File.exists?(FULLCALENDAR_СUSTOM_SETTINGS_FILE_PATH) ? YAML.load_file(FULLCALENDAR_СUSTOM_SETTINGS_FILE_PATH) || {} : {}
default_config = {
  editable: true,
  header: {
    left: 'prev,next today',
    center: 'title',
    right: 'month,agendaWeek,agendaDay'
  },
  defaultView: 'month',
  height: 800,
  firstDay: 1,
  monthNames: ['Январь','Февраль','Март','Апрель','Май','Июнь','Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'],
  monthNamesShort: ['Янв.','Фев.','Март','Апр.','Май','Июнь','Июль','Авг.','Сент.','Окт.','Ноя.','Дек.'],
  dayNames: ['Воскресенье','Понедельник','Вторник','Среда','Четверг','Пятница','Суббота'],
  dayNamesShort: ['ВС','ПН','ВТ','СР','ЧТ','ПТ','СБ'],
  buttonText: {
    prev: 'Предыдущий',
    next: 'Следующий',
    today: "Сегодня",
    month: "Месяц",
    week: "Неделя",
    day: "День"
  },
  axisFormat: 'HH:mm',
  dragOpacity: {
    agenda: '.5'
  },
  slotMinutes: 15,
  timeFormat: 'H:mm',
  displayEventEnd: true
}
Calendarik::Config = default_config.merge!(custom_config)
