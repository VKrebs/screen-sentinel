using System.Diagnostics;
using System.ServiceProcess;

namespace ScreenSentinel.WindowsService;

public class ScreenSentinelService : ServiceBase
{
    public ScreenSentinelService()
    {
        ServiceName = "ScreenSentinel";
        CanHandleSessionChangeEvent = true;
    }

    public void DebugStart(string[] args) => OnStart(args);
    public void DebugStop() => OnStop();

    protected override void OnStart(string[] args)
    {
        base.OnStart(args);
        LogEvent("Screen Sentinel Service started.");
    }

    protected override void OnSessionChange(SessionChangeDescription changeDescription)
    {
        base.OnSessionChange(changeDescription);

        switch (changeDescription.Reason)
        {
            case SessionChangeReason.SessionLogon:
                LogEvent($"User logged in. Session ID: {changeDescription.SessionId}.");
                break;
            case SessionChangeReason.SessionLogoff:
                LogEvent($"User logged off. Session ID: {changeDescription.SessionId}.");
                break;
            case SessionChangeReason.SessionLock:
                LogEvent($"User locked the session. Session ID: {changeDescription.SessionId}.");
                break;
            case SessionChangeReason.SessionUnlock:
                LogEvent($"User unlocked the session. Session ID: {changeDescription.SessionId}.");
                break;
        }
    }

    protected override void OnStop()
    {
        base.OnStop();
        LogEvent("Screen Sentinel Service stopped.");
    }

    private void LogEvent(string message)
    {
        try
        {
            EventLog.WriteEntry(ServiceName, message, EventLogEntryType.Information);
        }
        catch (Exception e)
        {
            Console.WriteLine($"Error writing to Event Log: {e.Message}");
        }
    }
}