class tiempo:

    def __init__(self, id,dia,mes,ano,diasemana,diadelano,vacaciones,findesemana,semanadelano):
        self.id = id
        self.dia = dia
        self.mes = mes
        self.ano = ano
        self.diasemana = diasemana
        self.diadelano = diadelano
        self.vacaciones = vacaciones
        self.findesemana = findesemana
        self.semanadelano = semanadelano

    def __eq__(self, other):
        return self.ano == other.ano \
               and self.mes == other.mes \
                        and self.dia == other.dia

    def __hash__(self):
        return hash(('ano', self.ano,
                     'mes', self.mes,
                     'dia', self.dia))