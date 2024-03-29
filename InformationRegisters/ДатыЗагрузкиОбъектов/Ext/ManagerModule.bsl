﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Записывает дату загрузки объекта на устройство
//
// Параметры:
//  ОбъектСсылка - СправочникСсылка, ДокументСсылка - Ссылка на прикладной объект.
// 
Процедура ОбновитьДатуПоследнегоИзмененияОбъекта(ОбъектСсылка, ДатаАктуальности = Неопределено) Экспорт

	Если НЕ ЗначениеЗаполнено(ДатаАктуальности) Тогда
		ДатаАктуальности = ТекущаяДата();
	КонецЕсли;		
	
	НаборЗаписей = РегистрыСведений.ДатыЗагрузкиОбъектов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(ОбъектСсылка);
	НаборЗаписей.Записать();

	МенеджерЗаписиРегистра = РегистрыСведений.ДатыЗагрузкиОбъектов.СоздатьМенеджерЗаписи();
	МенеджерЗаписиРегистра.Объект = ОбъектСсылка;
	МенеджерЗаписиРегистра.Период = ДатаАктуальности;
	МенеджерЗаписиРегистра.Записать();

КонецПроцедуры

// Возвращает признак того, что объект был загружен с сервера
//
// Параметры:
//  ОбъектСсылка - СправочникСсылка, ДокументСсылка - Ссылка на прикладной объект.
// 
// Возвращаемое значение:
//  Истина - Если в регистре есть записи по указанному объекту.
//
Функция ОбъектБылЗагруженССервера(ОбъектСсылка) Экспорт

	НаборЗаписей = РегистрыСведений.ДатыЗагрузкиОбъектов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(ОбъектСсылка);
	НаборЗаписей.Прочитать();

	Возврат НаборЗаписей.Количество() > 0;

КонецФункции

#КонецОбласти


#КонецЕсли

