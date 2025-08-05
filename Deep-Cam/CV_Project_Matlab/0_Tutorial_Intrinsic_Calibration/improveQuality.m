
function improveQualityCallback(hObject, eventdata, handles)
    msgbox('Running... ', 'Running', 'modal');

    try
        % 运行 .m 文件
        run('Deep_SRCNN.m');
        
        % 使用 msgbox 显示成功消息
        msgbox('All image processing completed!', 'Notice', 'none');
        
    catch err
        % 捕获错误并提示
        errMsg = ['Error running code.', err.message];
        msgbox(errMsg, 'Wrong', 'error');
    end
end