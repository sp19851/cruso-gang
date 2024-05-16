-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Май 16 2024 г., 16:02
-- Версия сервера: 10.4.32-MariaDB
-- Версия PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `qbcoreframework_126064`
--

-- --------------------------------------------------------

--
-- Структура таблицы `cruso_sellers`
--

CREATE TABLE `cruso_sellers` (
  `id` int(155) NOT NULL,
  `id_seller` varchar(155) NOT NULL,
  `item` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `cruso_sellers_accounts`
--

CREATE TABLE `cruso_sellers_accounts` (
  `id` int(11) NOT NULL,
  `id_seller` varchar(155) NOT NULL,
  `account` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `cruso_sellers`
--
ALTER TABLE `cruso_sellers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_seller` (`id_seller`,`item`);

--
-- Индексы таблицы `cruso_sellers_accounts`
--
ALTER TABLE `cruso_sellers_accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_seler` (`id_seller`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `cruso_sellers`
--
ALTER TABLE `cruso_sellers`
  MODIFY `id` int(155) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `cruso_sellers_accounts`
--
ALTER TABLE `cruso_sellers_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
