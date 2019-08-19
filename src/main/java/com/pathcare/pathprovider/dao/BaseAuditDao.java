package com.pathcare.pathprovider.dao;



import com.pathcare.pathprovider.WebInfoFilter;
import com.pathcare.pathprovider.domain.Audit;
import java.net.Inet4Address;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class BaseAuditDao {

    private static final Logger LOG = LoggerFactory.getLogger(BaseAuditDao.class);

    private AuditDao auditDao;

    public BaseAuditDao(AuditDao auditDao) {
        this.auditDao = auditDao;
    }

    protected void audit(String username, String detail, String storedProcName, String process) {
        ThreadLocal<Map<String, String>> threadLocal = WebInfoFilter.stringThreadLocal;
        String ipAddress = threadLocal.get().get("ipAddress");
        String browser = threadLocal.get().get("browser");
        Audit audit = new Audit(username, ipAddress, storedProcName, detail, process, 0, 0, 0,browser);
        auditDao.insertAudit(audit);
        LOG.info("Audit: " + audit);

    }

    protected void audit(String username, String detail, String storedProcName, String process, int patId, Integer requisitionNumber, int specimenId) {
        ThreadLocal<Map<String, String>> threadLocal = WebInfoFilter.stringThreadLocal;
        String ipAddress = threadLocal.get().get("ipAddress");
        String browser = threadLocal.get().get("browser");
        Audit audit = new Audit(username, ipAddress, storedProcName, detail, process, patId, requisitionNumber, specimenId,browser);
        auditDao.insertAudit(audit);
        LOG.info("Audit: " + audit);
    }

    private String getIpAddress() {
        String ipAddress = "";
        try {
            ipAddress = Inet4Address.getLocalHost().getHostAddress();
        } catch (Exception e) {
            LOG.error(String.format("Error occurred while trying to get IP address, {}") + e.getMessage());
        }
        return ipAddress;
    }
}
