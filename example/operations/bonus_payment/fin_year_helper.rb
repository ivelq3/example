module BonusPayment
  class FinYearHelper
    FIN_YEAR_START = { day: 1, month: 4 }.freeze

    def fin_year_start_from_string(string)
      date = Date.parse(string)
      fin_year_start_from_date(date)
    end

    def fin_year_start_from_date(date)
      year = detect_fin_year(date)
      Date.new(year, FIN_YEAR_START[:month], FIN_YEAR_START[:day])
    end

    def fin_year_full(fin_year_start_date)
      return if fin_year_start_date.nil?

      fin_year_end_date = fin_year_start_date + 1.year - 1.day
      [fin_year_start_date, fin_year_end_date].map {|date| date.strftime('%d.%m.%Y') }.join('-')
    end

    def fin_year_start_valid?(date)
      date.day == FIN_YEAR_START[:day] && date.month == FIN_YEAR_START[:month]
    end

    private

    def detect_fin_year(date)
      date.month < FIN_YEAR_START[:month] ? date.year - 1 : date.year
    end
  end
end
