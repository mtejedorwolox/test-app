class TransactionBuilder
  def self.build_with_json(json)
    build_with_params(
      DateTime.parse(json["date"]),
      BigDecimal(json["rate"]),
      BigDecimal(json["amount"]),
      BigDecimal(json["total"]),
      BigDecimal(json["fee"]),
      json["type"]
    )
  end

  def self.build_with_params(date, rate, amount, total, fee, type)
    Transaction.new(date, rate, amount, total, fee, type).apply_fee
  end
end
