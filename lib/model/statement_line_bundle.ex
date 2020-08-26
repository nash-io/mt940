defmodule MT940.StatementLineBundle do
  @moduledoc false

  alias MT940.StatementLine
  alias MT940.StatementLineInformation

  defstruct [
    :amount,
    :funds_code,
    :value_date,
    :entry_date,
    :account_holder,
    :details,
    :account_number,
    :iban,
    :reference,
    :bank_code,
    :code,
    :transaction_description
  ]

  @type t :: %__MODULE__{}

  @doc false
  def new(statement_line, statement_line_info) do
    %__MODULE__{
      amount:                   statement_line.amount,
      funds_code:               statement_line.funds_code,
      value_date:               statement_line.value_date,
      entry_date:               statement_line.entry_date,
      account_holder:           parse_account_holder(statement_line),
      details:                  statement_line_info.details,
      account_number:           statement_line_info.account_number,
      iban:                     parse_iban(statement_line_info),
      reference:                parse_reference(statement_line_info),
      bank_code:                statement_line_info.bank_code,
      code:                     statement_line_info.code,
      transaction_description:  statement_line_info.transaction_description
    }
  end

  defp parse_iban(%StatementLineInformation{details: details}) when is_list(details) do
    details
    |> Enum.join(",")
    |> String.split(",")
    |> Enum.at(1)
    |> Kernel.||("")
    |> String.replace("C/", "")
    |> case do
      "" -> nil
      iban -> iban
    end
  end

  defp parse_reference(%StatementLineInformation{details: details}) when is_list(details) do
    details
    |> Enum.join(",")
    |> String.split(",")
    |> Enum.at(2)
  end

  defp parse_account_holder(%StatementLine{transaction_description: description}) when is_binary(description) do
    description
    |> String.split(",")
    |> Enum.at(1)
  end

  defp parse_account_holder(%StatementLine{transaction_description: nil}), do: nil
end
