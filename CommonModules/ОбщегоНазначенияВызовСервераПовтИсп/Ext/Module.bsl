﻿#Область ПрограммныйИнтерфейс

// Получает значение любой константы.
//
Функция ПолучитьЗначениеКонстанты(ИмяКонстанты) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Константы[ИмяКонстанты].Получить();
	
КонецФункции

Функция ПолучитьСинонимКонфигурации() Экспорт
	
	Возврат Метаданные.Синоним;
	
КонецФункции

// Возвращает  элемент справочника Корзины для текущего пользвателя
//
Функция ПолучитьКорзину() Экспорт
	
	ПустойУникальныйИдентификатор = ОбщегоНазначенияКлиентСервер.ПустойУникальныйИдентификатор();
	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	
	Если ТекущийПользователь.ИдентификаторПользователяИБ = ПустойУникальныйИдентификатор Тогда
		ТекстСообщения = "Для использования корзины войдите в программу под авторизованным пользователем!";
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Возврат Неопределено;	
	КонецЕсли;
	
	Корзина = Справочники.Корзины.НайтиПоРеквизиту("Пользователь", ПараметрыСеанса.ТекущийПользователь);
	
	Если НЕ ЗначениеЗаполнено(Корзина) Тогда
		
		КорзинаОбъект = Справочники.Корзины.СоздатьЭлемент();
		КорзинаОбъект.Пользователь = ПараметрыСеанса.ТекущийПользователь; 
		КорзинаОбъект.Записать();
		Корзина = КорзинаОбъект.Ссылка;
	
	КонецЕсли;
	
	Возврат Корзина;
	
КонецФункции

#КонецОбласти