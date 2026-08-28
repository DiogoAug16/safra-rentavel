from contextlib import redirect_stdout
from decimal import Decimal
from io import StringIO
from types import SimpleNamespace
from unittest import TestCase
from unittest.mock import MagicMock, patch

import main


class TestTestCommand(TestCase):
    @patch("main.get_connection")
    def test_shows_percentage_suffixes_only_for_probability_columns(self, get_connection):
        cursor = MagicMock()
        cursor.description = [
            SimpleNamespace(name=name)
            for name in (
                "caso",
                "nome_safra",
                "probabilidade_sim",
                "probabilidade_nao",
                "classe_prevista",
                "recomendacao",
            )
        ]
        cursor.fetchall.return_value = [
            (
                "01_baixo_risco",
                "Soja",
                Decimal("97.38"),
                Decimal("2.62"),
                "Sim",
                "Alta probabilidade de rentabilidade.",
            )
        ]
        get_connection.return_value.__enter__.return_value.cursor.return_value.__enter__.return_value = cursor

        output = StringIO()
        with redirect_stdout(output):
            main.test()

        self.assertIn(
            "01_baixo_risco | Soja | 97.38% | 2.62% | Sim | "
            "Alta probabilidade de rentabilidade.",
            output.getvalue(),
        )
        self.assertNotIn("Soja%", output.getvalue())
        self.assertNotIn("Sim%", output.getvalue())


class TestLogOddsCommand(TestCase):
    @patch("main.get_connection")
    def test_shows_probabilities_as_percentages(self, get_connection):
        cursor = MagicMock()
        cursor.description = [
            SimpleNamespace(name=name)
            for name in (
                "feature",
                "valor",
                "probabilidade_sim",
                "probabilidade_nao",
                "log_odds",
                "efeito",
            )
        ]
        cursor.fetchall.return_value = [
            (
                "produtividade_estimada",
                "Baixa",
                Decimal("15.87"),
                Decimal("41.27"),
                Decimal("-0.9555"),
                "Nao",
            )
        ]
        get_connection.return_value.__enter__.return_value.cursor.return_value.__enter__.return_value = cursor

        output = StringIO()
        with redirect_stdout(output):
            main.log_odds()

        self.assertIn(
            "produtividade_estimada | Baixa | 15.87% | 41.27% | -0.9555 | Nao",
            output.getvalue(),
        )
