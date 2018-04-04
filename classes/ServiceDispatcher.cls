public with sharing class ServiceDispatcher {

    private static ServiceDispatcher dispatcher;
    private ServicesMetadataIOC servicesMetadata;
    private ServiceExecutor serviceExecutor;

    private ServiceDispatcher() {
        this.serviceExecutor = new serviceExecutor();
    }

    /*
     * Public interface
     */
    public static ServiceDispatcher getDispatcher() {
        if (dispatcher == null) {
            dispatcher = new ServiceDispatcher();
        }
        return dispatcher;
    }

    public void launchServices() {
        this.servicesMetadata = new ServicesMetadataIOC();
        for (Service_IOC__mdt serviceMetadata : this.servicesMetadata.servicesMetadata.values()) {
            Type serviceType = Type.forName(serviceMetadata.Apex_Class_Name__c);
            if (serviceType == null) {
                //ToDo: log this
                System.debug('Invalid name ' + serviceMetadata.Apex_Class_Name__c);
                continue;
            }
            Service service = (Service) serviceType.newInstance();
            this.serviceExecutor.execute(service);
        }
    }

    public Boolean isServiceActive(String serviceName) {
        Service_IOC__mdt service = this.servicesMetadata.getServiceByName(serviceName);
        if (service == null) {
            return false;
        }
        return true;
    }

    /*
     * Helper classes
     */
    private class ServiceDispatcherException extends Exception {

    }

    private class ServicesMetadataIOC {

        private final SObjectType sObjectType;
        public final Map<String, Service_IOC__mdt> servicesMetadata {public get; private set;}

        public ServicesMetadataIOC() {
            this.sObjectType = this.getMetadataType();
            this.servicesMetadata = this.getMetadataServices();
        }

        private SObjectType getMetadataType() {
            SObjectType result = null;
            if (Trigger.isExecuting && Trigger.size > 0) {
                if (Trigger.isInsert || Trigger.isUpdate) {
                    result = Trigger.new[0].getSobjectType();
                } else {
                    result = Trigger.old[0].getSobjectType();
                }
            } else {
                throw new ServiceDispatcher.ServiceDispatcherException('Wrong dispatcher context.');
            }
            return result;
        }

        private Map<String, Service_IOC__mdt> getMetadataServices() {
            Map<String, Service_IOC__mdt> result = new Map<String, Service_IOC__mdt>();
            List<Service_IOC__mdt> services = [
                SELECT Id
                    , DeveloperName
                    , Apex_Class_Name__c
                    , Object__c
                FROM Service_IOC__mdt
                WHERE Object__r.DeveloperName = :sObjectType.getDescribe().getName()
                    AND Is_Active__c = TRUE
            ];
            for (Service_IOC__mdt service : services) {
                result.put(service.Apex_Class_Name__c, service);
            }
            return result;
        }

        private Service_IOC__mdt getServiceByName(String className) {
            return this.servicesMetadata.get(className);
        }
    }

    private class ServiceExecutor {

        public void execute(Service service) {
            try {
                this.executeService(service);
            } catch (Exception ex) {
                System.debug(ex);
            }
        }

        private void executeService(Service service) {
            if (Trigger.isBefore) {
                if (Trigger.isInsert && service instanceof BeforeInsertable) {
                    this.executeService((BeforeInsertable) service);
                } else
                if (Trigger.isUpdate && service instanceof BeforeUpdateable) {
                    this.executeService((BeforeUpdateable) service);
                } else
                if (Trigger.isDelete && service instanceof BeforeDeletable) {
                    this.executeService((BeforeDeletable) service);
                } else
                if (Trigger.isUndelete && service instanceof BeforeUndeletable) {
                    this.executeService((BeforeUndeletable) service);
                }
            } else
            if (Trigger.isAfter) {
                if (Trigger.isInsert && service instanceof AfterInsertable) {
                    this.executeService((AfterInsertable) service);
                } else
                if (Trigger.isUpdate && service instanceof AfterUpdateable) {
                    this.executeService((AfterUpdateable) service);
                } else
                if (Trigger.isDelete && service instanceof AfterDeletable) {
                    this.executeService((AfterDeletable) service);
                }
            }
        }

        private void executeService(BeforeInsertable service) {
            service.executeBeforeInsert(Trigger.new);
        }

        private void executeService(BeforeUpdateable service) {
            service.executeBeforeUpdate(Trigger.new, Trigger.oldMap);
        }

        private void executeService(BeforeDeletable service) {
            service.executeBeforeDelete(Trigger.old);
        }

        private void executeService(BeforeUndeletable service) {
            service.executeBeforeUndelete(Trigger.old);
        }

        private void executeService(AfterInsertable service) {
            service.executeAfterInsert(Trigger.new);
        }

        private void executeService(AfterUpdateable service) {
            service.executeAfterUpdate(Trigger.new, Trigger.oldMap);
        }

        private void executeService(AfterDeletable service) {
            service.executeAfterDelete(Trigger.old);
        }

    }

}