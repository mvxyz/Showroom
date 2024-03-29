﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Обработчик обновления информационной базы.
Процедура ПереместитьДанныеВНовыйРегистр() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	РегистрСведений.УдалитьГруппыЗначенийДоступа КАК УдалитьГруппыЗначенийДоступа";
	
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ТипыВладельцев",
		УправлениеДоступомСлужебныйПовтИсп.ВозможныеПраваДляНастройкиПравОбъектов().ТипыВладельцев);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УдалитьГруппыЗначенийДоступа.ЗначениеДоступа КАК Объект,
	|	УдалитьГруппыЗначенийДоступа.ГруппаЗначенийДоступа КАК Родитель,
	|	УдалитьГруппыЗначенийДоступа.НаследоватьПраваРодителей КАК Наследовать
	|ИЗ
	|	РегистрСведений.УдалитьГруппыЗначенийДоступа КАК УдалитьГруппыЗначенийДоступа
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ИдентификаторыОбъектовМетаданных КАК ИдентификаторыОбъектовМетаданных
	|		ПО (УдалитьГруппыЗначенийДоступа.ЗначениеДоступа = УдалитьГруппыЗначенийДоступа.ГруппаЗначенийДоступа)
	|			И (УдалитьГруппыЗначенийДоступа.НаследоватьПраваРодителей = ЛОЖЬ)
	|			И (ТИПЗНАЧЕНИЯ(УдалитьГруппыЗначенийДоступа.ЗначениеДоступа) = ТИПЗНАЧЕНИЯ(ИдентификаторыОбъектовМетаданных.ЗначениеПустойСсылки))
	|			И (ИдентификаторыОбъектовМетаданных.ЗначениеПустойСсылки В (&ТипыВладельцев))";
	
	НачатьТранзакцию();
	Попытка
		РезультатЗапроса = Запрос.Выполнить();
		
		Если Не РезультатЗапроса.Пустой() Тогда
			НаборЗаписей = РегистрыСведений.НаследованиеНастроекПравОбъектов.СоздатьНаборЗаписей();
			НаборЗаписей.Загрузить(РезультатЗапроса.Выгрузить());
			НаборЗаписей.Записать();
		КонецЕсли;
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Обработчик обновления информационной базы.
Процедура ОчиститьРегистр() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	РегистрСведений.УдалитьГруппыЗначенийДоступа КАК УдалитьГруппыЗначенийДоступа";
	
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли