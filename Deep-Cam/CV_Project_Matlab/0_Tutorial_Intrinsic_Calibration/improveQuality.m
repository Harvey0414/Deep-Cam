
function improveQualityCallback(hObject, eventdata, handles)
    msgbox('Running... ', 'Running', 'modal');

    try
        % ���� .m �ļ�
        run('Deep_SRCNN.m');
        
        % ʹ�� msgbox ��ʾ�ɹ���Ϣ
        msgbox('All image processing completed!', 'Notice', 'none');
        
    catch err
        % ���������ʾ
        errMsg = ['Error running code.', err.message];
        msgbox(errMsg, 'Wrong', 'error');
    end
end